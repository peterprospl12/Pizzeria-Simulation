# Ada - simulation

Opis projektu zawierać będzie program przykładowy realizujący zadanie producentów, konsumentów i bufora, z możliwością dostosowania do własnego zadania. Program ten ma na celu rozwiązanie problemów związanych z przetwarzaniem i komunikacją między wątkami w kontekście tematyki produkcji i konsumpcji różnych rodzajów produktów. 

## Tematyka projektu

Tematem projektu jest **zarządzanie produkcją i dostawą jedzenia w restauracji**. Producenci to dostawcy, którzy wytwarzają różne składaniki do potraw, a konsumenci to klienci, którzy zamawiają potrawy. Bufor stanowi restauracje, która odpowiada za przyjęcie zamówień, odebranie dostaw oraz wydanie potraw .

## Zasada działania programu

- Producenci wytwarzają różne składniki do dań w losowych chwilach i wysyłają je do restauracji.
- Jeśli restauracja ma odpowiednią ilośc składników w magazynie, to przyjmuje dostawe.
- Konsumenci składają zamówienia na potrawy.
- Bufor wydaje zestawy potraw, gdy są dostępne wszystkie składniki danego zestawu. Po wydaniu zestawu, składniki znikają z magazynu.

## Problemy do rozwiązania

1. **Zagubienie produktów**: Aktualnie, gdy producent nie może umieścić dania na kuchennym stole (buforze), danie znika. To nie jest satysfakcjonujące. Należy poprawić ten aspekt, aby np. oznaczyć, że danie jest oczekujące na umieszczenie w buforze.

2. **Zakleszczenia**: Musimy uniknąć sytuacji, w której bufor jest pełny, ale nie ma składników dostępnych do utworzenia zestawu potraw. Należy przewidzieć i zapobiec takim zakleszczeniom w systemie.

3. **Nierównomierny popyt na produkty**: Należy zwrócić uwagę na równomierne dostarczanie i konsumpcję różnych rodzajów dań. Nie może być sytuacji, w której bufor jest przepełniony daniami, na które jest niski popyt, podczas gdy brakuje popularnych potraw.

4. **Optymalizacja wykorzystania zasobów**: Należy starać się jak najmniej spowalniać system, zapewniając optymalne wykorzystanie zasobów, tak aby nie dochodziło do głodzenia żadnego z procesów (kucharze lub kelnerzy).

## Wymagania i założenia
- Mechanizm losowania: Program musi wykorzystywać mechanizm losowania przynajmniej raz w trakcie rozwiązywania problemu.
- Rozwiązanie problemów związanych z dostawą i produkcją dań w restauracji.
- Zminimalizowanie ryzyka zagubienia dań i zapobieżenie zakleszczeniom.
- Optymalne wykorzystanie zasobów, tak aby nie dochodziło do głodzenia żadnego z procesów.


---

Powyższy plik `read.me` zawiera ogólne informacje dotyczące projektu i stanowi instrukcję dotyczącą problemu producentów, konsumentów i bufora w kontekście tematyki restauracji. Projekt ten ma na celu dostarczenie rozwiązania dla problemów związanych z przetwarzaniem i komunikacją między wątkami oraz zapewnić optymalne zarządzanie produkcją i dostawą dań w restauracji.
