# README

This app is about implementing a simple pizza order overview for a restaurant. All orders need to be listed, with the items they contain, their details and the total price. In addition, it is possible to mark orders as completed.

## Acceptance Criteria

In data/orders.json you will find a sample listing that you can use as a basis for your listing. Use it to fill the corresponding fields in the UI.

Furthermore, to mark orders as completed, you can click on the respective button. It should send a PATCH request to a /orders/:id backend endpoint to update the order. Completed orders should then simply no longer be displayed in the UI.

At last, the total price for a pizza order is to be calculated and displayed. For a pizza order several pizzas can be ordered, per pizza the desired size and also special requests (extra ingredients and omit ingredients) can be specified. In addition, there is a possibility to reduce the price of the order by using various discount codes.

- The price of a pizza depends on the size. Per size there is a "multiplier" that is multiplied by the base price of the pizza.
- Extra ingredients are also provided with this multiplier.
- Ingredients that are omitted during preparation do not change the price of the pizza.
- Promotion codes allow to get pizzas for free; e.g., two small salami pizzas for the price of one. Extra ingredients will still be charged though. Multiple promotion codes can be specified per order. A promotion code can also be applied more than once to the same order (a 2-for-1 code automatically reduces 4 pizzas to 2 for one order).
- A discount code reduces the total invoice amount by a percentage.

## Requirements
- Ruby 2.7.1
- Rails 6.1.4
## Database
- Postgres 13.2
## Installation steps
- git clone git@github.com:dev-asadhameed/Pizza-Orders-App
- cd Pizza-Orders-App
- `bundle install`
- `yarn`
- `rails s`
## If I had extra time
- I can write test cases.
- Improvements in UI/UX.
## Quick start for local development
The application will be running at http://localhost:3000/
