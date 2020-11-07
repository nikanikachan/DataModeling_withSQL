-- Data analysis within pgadmin database

-- VIEW 1: grouping transactions of each cardholder
ALTER TABLE transaction
RENAME COLUMN id TO transaction_id;

CREATE VIEW view1 AS
SELECT card_holder.id,
       card_holder.name,
	   COUNT(transaction_id) AS "Num_of_transactions"
FROM card_holder
INNER JOIN credit_card ON card_holder.id = credit_card.id_card_holder
INNER JOIN transaction ON credit_card.card = transaction.card
GROUP BY card_holder.id, card_holder.name
ORDER BY COUNT(transaction_id) DESC;

---VIEW 2: 100 Highest transactions from 7 to 9 am

CREATE VIEW view2 as
SELECT
  TRANSACTION_ID,
  EXTRACT(HOUR FROM date) AS hour,
  ROUND (AMOUNT,2)
FROM transaction
WHERE
	EXTRACT(HOUR FROM date)BETWEEN 7 AND 9
GROUP BY TRANSACTION_ID
ORDER BY AMOUNT desc
LIMIT 100;


--VIEW 3: count transactions less than 2 dollars
CREATE VIEW view3 as
SELECT
	credit_card.id_card_holder, 
	card_holder.name,
	SUM(CASE WHEN transaction.amount<2.00 THEN 1 ELSE 0 END) as countoflessthan2
FROM credit_card
INNER JOIN transaction ON credit_card.card = transaction.card
INNER JOIN card_holder ON card_holder.id = credit_card.id_card_holder
GROUP BY credit_card.id_card_holder, card_holder.name
ORDER BY countoflessthan2 desc;

--VIEW 4: Top 5 merchants being hacked

ALTER TABLE merchant_category
RENAME COLUMN name TO merch_catname;

ALTER TABLE merchant
RENAME COLUMN id TO merchname_id;

CREATE VIEW view4 as
SELECT
    merchant.merchname_id,
	merchant.name,
	SUM(CASE WHEN transaction.amount<2.00 THEN 1 ELSE 0 END) as countoflessthan2,
	merchant_category.merch_catname
FROM merchant
INNER JOIN transaction ON merchant.merchname_id = transaction.id_merchant
INNER JOIN merchant_category ON merchant_category.id=merchant.id_merchant_category
GROUP BY merchant.merchname_id, merchant.name, merchant_category.merch_catname
ORDER BY countoflessthan2 desc
LIMIT 5;
