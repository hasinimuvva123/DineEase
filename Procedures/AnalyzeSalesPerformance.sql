/*
This procedure analyzes the sales performance by calculating moving averages of total revenue over a specified time period.
It retrieves sales data from the ORDERS table, aggregates it by month, and calculates the moving average for the past 3 months.
The results are outputted to provide insights into revenue patterns.
*/
CREATE OR REPLACE PROCEDURE AnalyzeSalesPerformance AS
    moving_avg NUMBER;

BEGIN
    -- Retrieve sales data from the ORDERS table
    FOR sales_data IN (
    SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
           SUM(order_amount) AS total_revenue
    FROM ORDERS
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
    ORDER BY TO_CHAR(order_date, 'YYYY-MM')
    ) LOOP
        -- Calculate the moving average for the past 3 months
        SELECT AVG(total_revenue) INTO moving_avg
        FROM (
            SELECT total_revenue
            FROM (
                SELECT SUM(order_amount) AS total_revenue
                FROM ORDERS
                WHERE TRUNC(order_date, 'MONTH') BETWEEN ADD_MONTHS(TO_DATE(sales_data.month, 'YYYY-MM'), -2) AND TO_DATE(sales_data.month, 'YYYY-MM')
                GROUP BY TO_CHAR(order_date, 'YYYY-MM')
                ORDER BY TO_CHAR(order_date, 'YYYY-MM')
            )
        );
        
        -- Output the results or perform further analysis
        DBMS_OUTPUT.PUT_LINE('Month: ' || sales_data.month || ', Moving Average: ' || moving_avg);
    END LOOP;
END;
/


EXECUTE AnalyzeSalesPerformance;
