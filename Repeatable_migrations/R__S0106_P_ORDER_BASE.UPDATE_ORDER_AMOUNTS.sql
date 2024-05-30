CREATE OR REPLACE PROCEDURE INTEL_ASSESMENT."ORDER_BASE".update_order_amounts()
    RETURNS VARCHAR
    LANGUAGE SQL
AS
$$
DECLARE
    total_detail_amount NUMERIC(12,2);
    total_header_amount NUMERIC(12,2);
BEGIN
    -- Calculate total amount for each order detail and update ORDER_DETAIL
    UPDATE ORDER_BASE.ORDER_DETAIL
    SET TOTAL_AMOUNT = QTY * PRICE;

    -- Calculate total amount for each customer and update ORDER_HEADER
    UPDATE ORDER_BASE.ORDER_HEADER oh
    SET oh.TOTAL_AMOUNT = (
        SELECT SUM(OD.TOTAL_AMOUNT) 
        FROM ORDER_BASE.ORDER_DETAIL OD
        WHERE OD.CUSTOMER_ID = oh.CUSTOMER_ID
    );

    -- Get the total amount for all order details
    SELECT SUM(QTY * PRICE) INTO total_detail_amount
    FROM ORDER_BASE.ORDER_DETAIL;

    -- Get the total amount for all order headers
    SELECT SUM(TOTAL_AMOUNT) INTO total_header_amount
    FROM ORDER_BASE.ORDER_HEADER;

    RETURN 'Total amount updated successfully. New total detail amount: ' || total_detail_amount || ', New total header amount: ' || total_header_amount;
END;
$$;