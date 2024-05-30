CREATE PROCEDURE ORDER_BASE.UPDATE_TOTAL_AMOUNT()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN

    CALL update_order_amounts();
    
    -- Update order_header discount based on promotion
    UPDATE ORDER_BASE.ORDER_HEADER oh
    SET DISCOUNT = 
    (CASE
        WHEN  oh.COUPON_CODE in (''Discount'',''Loyalty'')
            -- AND oh.TOTAL_AMOUNT < 1000 
             AND p.CUSTOMER_CATEGORY IN (''Gold'', ''Silver'', ''Bronze'') 
             AND c.CUSTOMER_ID = oh.CUSTOMER_ID 
             -- AND p.CUSTOMER_CATEGORY = c.CATEGORY 
             AND oh.COUPON_CODE = ''Discount''
             AND p.PROMOTION_TYPE = oh.COUPON_CODE
                THEN p.PROMOTION_VALUE * oh.TOTAL_AMOUNT
        WHEN oh.COUPON_CODE IN (''Coupon_x'', ''Coupon_y'', ''Coupon_z'') 
             AND oh.CUSTOMER_ID = c.CUSTOMER_ID 
               AND p.CUSTOMER_CATEGORY IN (''Regular'')
                 AND oh.TOTAL_AMOUNT < 1000
                THEN oh.TOTAL_AMOUNT - (oh.TOTAL_AMOUNT * p.PROMOTION_VALUE)
        
        ELSE 0
        END)
    
    from ORDER_BASE.CUSTOMER c 
    JOIN ORDER_BASE.PROMOTION p ON p.CUSTOMER_CATEGORY = c.CATEGORY
    WHERE oh.CUSTOMER_ID = c.CUSTOMER_ID ;

 UPDATE ORDER_BASE.CUSTOMER c
SET LOYALTY_POINTS = c.LOYALTY_POINTS + p.PROMOTION_VALUE
FROM ORDER_BASE.ORDER_HEADER oh
JOIN ORDER_BASE.PROMOTION p ON oh.COUPON_CODE = p.PROMOTION_TYPE
WHERE c.CUSTOMER_ID = oh.CUSTOMER_ID
AND oh.TOTAL_AMOUNT > 1000
AND p.CUSTOMER_CATEGORY IN (''Gold'', ''Silver'', ''Bronze'')
AND c.CATEGORY = p.CUSTOMER_CATEGORY
AND oh.COUPON_CODE = ''Loyalty'';


    RETURN ''Total amounts updated successfully'';
END;
';