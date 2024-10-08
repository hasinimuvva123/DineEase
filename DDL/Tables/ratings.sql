SET SERVEROUTPUT ON;

DECLARE
    rating_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO rating_count
    FROM user_tables
    WHERE table_name = 'RATINGS';
        
    IF rating_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE Ratings (
                food_rating FLOAT,
                review_id INTEGER NOT NULL,
                item_id INTEGER NOT NULL,
                FOREIGN KEY (review_id) REFERENCES Service_reviews(review_id),
                FOREIGN KEY (item_id) REFERENCES items(item_id)
            )';

        dbms_output.put_line('Ratings table created successfully.');

    ELSE
        dbms_output.put_line('Ratings table already exists.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table Ratings: ' || sqlerrm);
END;
