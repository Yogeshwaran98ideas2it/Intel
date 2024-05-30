CREATE PROCEDURE INTEL_ASSESMENT."ORDER_BASE".INVOICE_GENERATE()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS '
BEGIN

    call UPDATE_TOTAL_AMOUNT();

    INSERT INTO INTEL_ASSESMENT.ORDER_BASE.INVOICE (
        ORDER_ID,
        ORDER_DATE,
        INVOICE_DATE,
        TAX_AMOUNT,
        TOTAL_AMOUNT,
        DISCOUNT,
        FINAL_INVOICE_AMT,
        CUSTOMER_ID,
        CREATE_DATE,
        CREATE_USER
    )
    SELECT 
        od.ORDER_ID,
        oh.ORDER_DATE AS ORDER_DATE_HEADER,
        od.create_date,
        oh.TOTAL_AMOUNT * 0.09 AS TAX_AMOUNT,
        oh.TOTAL_AMOUNT,
        oh.DISCOUNT,
        (oh.total_amount + 0.09) - oh.discount AS FINAL_INVOICE_AMT,
        oh.CUSTOMER_ID,
        oh.CREATE_DATE AS CREATE_DATE,
        oh.CREATE_USER
    FROM 
        ORDER_BASE.ORDER_HEADER oh
    JOIN 
        ORDER_BASE.ORDER_DETAIL od ON oh.customer_id = od.customer_id
    JOIN 
        ORDER_BASE.CUSTOMER c ON oh.CUSTOMER_ID = c.CUSTOMER_ID
    WHERE 
        oh.ORDER_DATE > CURRENT_DATE() AND
        c.STATUS = ''Active'';


    RETURN ''Invoice data inserted successfully'';
END;
';