[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/peterprospl12/Pizzeria-Simulation/blob/master/README.md)
[![pl](https://img.shields.io/badge/lang-pl-red.svg)](https://github.com/peterprospl12/Pizzeria-Simulation/blob/master/README.pl.md)


# Ada - Simulation

The project description will include a sample program that implements the producer-consumer problem with the option to customize it for your own task. This program aims to address issues related to thread processing and communication within the context of food production and delivery.

## Project Theme

The theme of the project is **managing food production and delivery in a restaurant**. Producers are the suppliers who produce various ingredients for dishes, while consumers are the customers who place orders. The buffer represents the restaurant, responsible for receiving orders, accepting deliveries, and serving dishes.

## Program Operation Principle

- Producers generate various ingredients for dishes at random intervals and send them to the restaurant.
- If the restaurant has the necessary ingredients in stock, it accepts the delivery.
- Consumers place orders for dishes.
- The buffer serves sets of dishes when all the required ingredients for a set are available. After serving a set, the ingredients are removed from the inventory.

## Problems to Solve

1. **Product Loss**: Currently, if a producer cannot place a dish on the kitchen table (buffer), the dish disappears. This is not satisfactory. It's necessary to improve this aspect, such as marking the dish as waiting to be placed in the buffer.

2. **Deadlocks**: We must avoid situations where the buffer is full, but there are no ingredients available to create a set of dishes. Predicting and preventing such deadlocks in the system is essential.

3. **Uneven Product Demand**: Attention must be paid to the even supply and consumption of different types of dishes. There should be no situations where the buffer is overloaded with dishes with low demand while popular dishes are unavailable.

4. **Optimizing Resource Utilization**: Efforts should be made to minimize system slowdown, ensuring the optimal use of resources to prevent any of the processes (chefs or waitstaff) from going hungry.

## Requirements and Assumptions

- Randomization Mechanism: The program must utilize a randomization mechanism at least once during problem-solving.
- Addressing issues related to food delivery and dish production in the restaurant.
- Minimizing the risk of dish loss and preventing deadlocks.
- Optimally utilizing resources to prevent any of the processes from going hungry.

---

The project description provides general information about the project and serves as an instruction regarding the producer-consumer and buffer problem in the context of a restaurant. This project aims to deliver a solution for issues related to thread processing and communication while ensuring optimal management of food production and delivery in a restaurant.
