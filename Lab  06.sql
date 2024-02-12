USE sakila;

#1
CREATE VIEW rental_count AS ( 
                              SELECT c.customer_id, c.email , CONCAT(first_name,"",last_name) AS full_name , COUNT(r.rental_id) AS sum_rental
                              FROM rental r
                              INNER JOIN customer c
                              ON r.customer_id = c.customer_id
                              GROUP BY c.customer_id, full_name , c.email);
                              



#2
CREATE TEMPORARY TABLE total_paid (
                                   SELECT rc.customer_id, rc.full_name, rc.email ,rc.sum_rental, SUM(p.amount)
                                   FROM rental_count rc
                                   INNER JOIN payment p
                                   ON rc.customer_id = p.customer_id
                                   GROUP BY rc.customer_id, rc.full_name, rc.email ,rc.sum_rental);
                                   
DROP TEMPORARY TABLE total_paid;

#3
WITH average_payment_per_rental  AS  (SELECT rc.customer_name, rc.email, rc.rental_count, tp.total_paid, tp.total_paid / rc.rental_count 
                                      FROM rental_count rc
                                      INNER JOIN total_paid tp
									  ON rc.customer_id = tp.customer_id);
                                   

SELECT customer_name, email, rental_count, total_paid, average_payment_per_rental
FROM customer_summary;                                  
                                   
                                   
                                   
                                   