## Table 1: plans

![image](https://github.com/SaibalPatraDS/PostgreSQL/assets/102281722/4b3c3ccd-6d57-4363-95cb-5fb401022b34)


**Customers can choose which plans to join Foodie-Fi when they first sign up.**

     1. Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

     2. Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

     3. Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

    4. When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.


## Table 2 : subscriptions

![image](https://github.com/SaibalPatraDS/PostgreSQL/assets/102281722/f3cc0065-bc47-4bc4-ad63-e6dc3f5b7aa2)


**Customer subscriptions show the exact date where their specific plan_id starts.**

    1. If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.

    2. When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.

    3. When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.
