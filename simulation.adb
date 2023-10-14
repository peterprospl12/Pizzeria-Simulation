-- A skeleton of a program for an assignment in programming languages
-- The students should rename the tasks of producers, consumers, and the buffer
-- Then, they should change them so that they would fit their assignments
-- They should also complete the code with constructions that lack there
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;


procedure Simulation is
   Number_Of_Products: constant Integer := 5;
   Number_Of_Assemblies: constant Integer := 3;
   Number_Of_Consumers: constant Integer := 2;
   subtype Product_Type is Integer range 1 .. Number_Of_Products;
   subtype Assembly_Type is Integer range 1 .. Number_Of_Assemblies;
   subtype Consumer_Type is Integer range 1 .. Number_Of_Consumers;
   Product_Name: constant array (Product_Type) of String(1 .. 9)
     := ("Ham      ", "Mushroom ", "Salami   ", "Dough    ", "Cheese   ");
   Assembly_Name: constant array (Assembly_Type) of String(1 .. 10)
     := ("Capriciosa", "Salami    ", "Margharita");
   package Random_Assembly is new
     Ada.Numerics.Discrete_Random(Assembly_Type);
   -- Producer produces determined product
   task type Producer is
      -- Give the Producer an identity, i.e. the product type
      entry Start(Product: in Product_Type);
   end Producer;

   -- Consumer gets an arbitrary assembly of several products from the buffer
   task type Consumer is
      -- Give the Consumer an identity
      entry Start(Consumer_Number: in Consumer_Type);
   end Consumer;

   -- In the Buffer, products are assemblied into an assembly
   task type Buffer is
      -- Accept a product to the storage provided there is a room for it
      entry Take(Product: in Product_Type; Number: in Integer; Accepted: out Boolean);
      -- Deliver an assembly provided there are enough products for it
      entry Deliver(Assembly: in Assembly_Type; Number: out Integer; Accepted: out Boolean);
   end Buffer;

   P: array ( 1 .. Number_Of_Products ) of Producer;
   K: array ( 1 .. Number_Of_Consumers ) of Consumer;
   B: Buffer;

   task body Producer is
      subtype Production_Time_Range is Integer range 3 .. 6;
      package Random_Production is new
        Ada.Numerics.Discrete_Random(Production_Time_Range);
      G: Random_Production.Generator;	--  random number generator
      Product_Type_Number: Integer;
      Product_Number: Integer;
      Production_Time: Integer;
      Accepted: Boolean;
   begin
      accept Start(Product: in Product_Type) do
         Random_Production.Reset(G);	--  start random number generator
         Product_Number := 1;
         Product_Type_Number := Product;
         Production_Time := Random_Production.Random(G);
         Accepted := False;
      end Start;
      Put_Line("[P] New producer of " & Product_Name(Product_Type_Number));
      loop
         Put_Line("[P] Started producing " & Product_Name(Product_Type_Number) &
                    " (est. time: " & Integer'Image(Production_Time) & " s)");
         delay Duration(Production_Time); --  simulate production
         Put_Line("[P] Produced product " & Product_Name(Product_Type_Number)
                  & " number "  & Integer'Image(Product_Number));
         -- Accept for storage
         loop
            select
               B.Take(Product_Type_Number, Product_Number, Accepted);
               if Accepted then
                  Product_Number := Product_Number + 1;
                  Put_Line("[P] Succesfully delivered " & Product_Name(Product_Type_Number));
                  exit;
               else
                  Put_Line("[P] Buffer rejected " & Product_Name(Product_Type_Number) & " (waiting 3s)");
                  delay Duration(5.0);
               end if;
            or delay Duration(3.0);
               Put_Line("[P] Buffer is too busy at the moment to accept " & Product_Name(Product_Type_Number) & " delivery!");
            end select;
         end loop;
      end loop;
   end Producer;
   
   task body Consumer is
      subtype Consumption_Time_Range is Integer range 4 .. 8;
      package Random_Consumption is new
        Ada.Numerics.Discrete_Random(Consumption_Time_Range);
      G: Random_Consumption.Generator;	--  random number generator (time)
      G2: Random_Assembly.Generator;	--  also (assemblies)
      Consumer_Nb: Consumer_Type;
      Assembly_Number: Integer;
      Consumption: Integer;
      Assembly_Type: Integer;
      Accepted: Boolean;
      Consumer_Name: constant array (1 .. Number_Of_Consumers) of String(1 .. 9)
        := ("Marcin   ", "Jessica  ");
   begin
      accept Start(Consumer_Number: in Consumer_Type) do
         Random_Consumption.Reset(G);	--  set generator
         Random_Assembly.Reset(G2);	--  also
         Consumer_Nb := Consumer_Number;
         Accepted := False;
      end Start;
      Put_Line("[C] New consumer " & Consumer_Name(Consumer_Nb));
      loop
         Assembly_Type := Random_Assembly.Random(G2);
         Consumption := Random_Consumption.Random(G); -- cooldown
         --  simulate consumption
         Put_Line("[C] " & Consumer_Name(Consumer_Nb) & " thinks what to eat today");
         delay Duration(Consumption);
         Put_Line("[C] " & Consumer_Name(Consumer_Nb) & " wants " & Assembly_Name(Assembly_Type));
         loop
            select
               B.Deliver(Assembly_Type, Assembly_Number, Accepted);
               if Accepted then
                  Put_Line(Consumer_Name(Consumer_Nb) & ": taken assembly " &
                             Assembly_Name(Assembly_Type) & " number " &
                             Integer'Image(Assembly_Number));
                  exit;
               else
                  Put_Line("[C] Not enough products for " & Assembly_Name(Assembly_Type) & " (waiting 3s)");
                  delay Duration(3.0);
               end if;
            or delay Duration(10.0);
               Put_Line("[C] " & Consumer_Name(Consumer_Nb) & " got angry and left the restaurant");
               exit;
            end select;
         end loop;
      end loop;
   end Consumer;

   task body Buffer is
      Storage_Capacity: constant Integer := 40;
	  isFull: exception;
      type Storage_type is array (Product_Type) of Integer;
      Storage: Storage_type
        := (0, 0, 0, 0, 0);
      Assembly_Content: array(Assembly_Type, Product_Type) of Integer
        := ((1, 2, 0, 2, 1),
            (0, 1, 1, 2, 1),
            (0, 0, 0, 2, 3));
      Max_Assembly_Content: array(Product_Type) of Integer;
      Assembly_Number: array(Assembly_Type) of Integer
        := (1, 1, 1);
      In_Storage: Integer := 0;

      procedure Setup_Variables is
      begin
         for W in Product_Type loop
            Max_Assembly_Content(W) := 0;
            for Z in Assembly_Type loop
               Max_Assembly_Content(W) := Max_Assembly_Content(W) + Assembly_Content(Z, W);
            end loop;
            Max_Assembly_Content(W) := Max_Assembly_Content(w) * 2;
         end loop;
      end Setup_Variables;

      function Can_Accept(Product: Product_Type) return Boolean is
         -- 1. Check if there is space in the warehouse.
         -- 2. Check if the maximum quantity of the specific product has been reached.
         -- 		If not, accept the delivery.
         -- 		If yes:
         -- 			Check if the remaining products have already reached their maximum level in the warehouse.
         -- 			If they have, accept the delivery.
         -- 		If they haven't, reject it.
         Free: Integer;
         MP: Boolean;
      begin
         if In_Storage >= Storage_Capacity then
			raise isFull;
            return False;
         end if;

         Free := Storage_Capacity - In_Storage;
         MP := true;
         if Storage(Product) >= Max_Assembly_Content(Product) then
            for I in Product_Type loop
               if Storage(I) < Max_Assembly_Content(I) then
                  MP := false;
                  exit;
               end if;
            end loop;

            if MP then 
               return True;
            else
               Put_Line("[B] We got enough of " & Product_Name(Product) & " in storage!");
               return False;
            end if;
         else
            return True;
         end if;
      end Can_Accept;

      function Can_Deliver(Assembly: Assembly_Type) return Boolean is
      begin
         for W in Product_Type loop
            if Storage(W) < Assembly_Content(Assembly, W) then
               return False;
            end if;
         end loop;
         return True;
      end Can_Deliver;
		
      procedure Storage_Contents is
      begin
         for W in Product_Type loop
            Put_Line("[B] Storage contents: " & Integer'Image(Storage(W)) & " "
                     & Product_Name(W));
         end loop;
      end Storage_Contents;

   begin
      Put_Line("[B] Pizzeria has opened");
      Setup_Variables;
      loop
         select
            accept Take(Product: in Product_Type; Number: in Integer; Accepted: out Boolean) do
               if Can_Accept(Product) then
                  Put_Line("[B] Received product " & Product_Name(Product) & " number " &
                             Integer'Image(Number));
                  Storage(Product) := Storage(Product) + 1;
                  In_Storage := In_Storage + 1;
                  Accepted := True;
               else
                  Put_Line("[B] Rejected product " & Product_Name(Product) & " number " &
                             Integer'Image(Number));
                  Accepted := False;
               end if;
			exception
				when isFull =>
					Put_Line("[B] Storage is full!");
            end Take;
            Storage_Contents;
         or
            accept Deliver(Assembly: in Assembly_Type; Number: out Integer; Accepted: out Boolean) do
               if Can_Deliver(Assembly) then
                  Put_Line("[B] Delivered pizza " & Assembly_Name(Assembly) & " number " &
                             Integer'Image(Assembly_Number(Assembly)));
                  for W in Product_Type loop
                     Storage(W) := Storage(W) - Assembly_Content(Assembly, W);
                     In_Storage := In_Storage - Assembly_Content(Assembly, W);
                  end loop;
                  Number := Assembly_Number(Assembly);
                  Assembly_Number(Assembly) := Assembly_Number(Assembly) + 1;
                  Accepted := True;
               else
                  Put_Line("[B] Lacking products for pizza " & Assembly_Name(Assembly));
                  Number := 0;
                  Accepted := False;
               end if;
            end Deliver;
            Storage_Contents;
         end select;
      end loop;
   end Buffer;
   
begin
   for I in 1 .. Number_Of_Products loop
      P(I).Start(I);
   end loop;
   for J in 1 .. Number_Of_Consumers loop
      K(J).Start(J);
   end loop;
end Simulation;