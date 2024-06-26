create view INTEL_ASSESMENT."ORDER_XFRM".V_INVOICE(
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
) as
SELECT 
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
FROM 
    INTEL_ASSESMENT.ORDER_BASE.INVOICE;