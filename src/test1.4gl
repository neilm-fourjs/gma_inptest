-- Define Arrays
DEFINE ma_stk_take_dt DYNAMIC ARRAY OF RECORD
  stk_code VARCHAR(16),
  stk_desc VARCHAR(40),
  uom VARCHAR(20),
  count_qty INTEGER,
  code_lbl VARCHAR(16),
  desc_lbl VARCHAR(40),
  uom_lbl VARCHAR(20),
  count_qty_lbl VARCHAR(20)
END RECORD

FUNCTION test1()
  DEFINE l_row SMALLINT

  OPEN WINDOW stk_take_input WITH FORM "test1"

  DIALOG ATTRIBUTES(FIELD ORDER FORM, UNBUFFERED)
    INPUT ARRAY ma_stk_take_dt
        FROM stk_take.*
        ATTRIBUTES(WITHOUT DEFAULTS, INSERT ROW = FALSE, DELETE ROW = FALSE)
      --       APPEND ROW = FALSE) -- this means you can't add rows!!

      BEFORE ROW
        LET l_row = ARR_CURR()
        DISPLAY "Before Row:", l_row, " StkCode:", NVL(ma_stk_take_dt[l_row].stk_code, "NULL")
        LET ma_stk_take_dt[l_row].code_lbl = "Stock Code:"
        LET ma_stk_take_dt[l_row].desc_lbl = "Desc:"
        LET ma_stk_take_dt[l_row].uom_lbl = "Uom:"
        LET ma_stk_take_dt[l_row].count_qty_lbl = "Count Qty:"

      AFTER FIELD stk_code
        DISPLAY SFMT("AF %1 : %2 = %3 (%4)",
            l_row,
            DIALOG.getCurrentItem(),
            NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
            NVL(ma_stk_take_dt[l_row].stk_code, "NULL"))
        IF (ma_stk_take_dt[l_row].stk_code IS NULL) THEN
          DISPLAY "CD1"
          CONTINUE DIALOG
        END IF
        IF (ma_stk_take_dt[l_row].stk_code IS NOT NULL)
                AND (ma_stk_take_dt[l_row].stk_desc IS NOT NULL)
            THEN
          DISPLAY "CD2"
          CONTINUE DIALOG
        END IF
        -- Check if Code has already been scanned
        DISPLAY SFMT("AF Done %1 : %2", l_row, DIALOG.getCurrentItem())

      BEFORE FIELD count_qty
        DISPLAY SFMT("BF %1 : %2 = %3 (%4)",
            l_row,
            DIALOG.getCurrentItem(),
            NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
            NVL(ma_stk_take_dt[l_row].count_qty, "NULL"))

      AFTER FIELD count_qty
        DISPLAY SFMT("AF %1 : %2 = %3 (%4)",
            l_row,
            DIALOG.getCurrentItem(),
            NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
            NVL(ma_stk_take_dt[l_row].count_qty, "NULL"))
        IF (ma_stk_take_dt[l_row].count_qty IS NULL) THEN
          DISPLAY "CD3"
          CONTINUE DIALOG
        END IF
        DISPLAY SFMT("AF Done %1 : %2", l_row, DIALOG.getCurrentItem())

      ON ACTION scan_barcode
        LET ma_stk_take_dt[l_row].stk_code = "ABCD" || l_row
        LET ma_stk_take_dt[l_row].count_qty = 1
        DISPLAY "SCAN:", ma_stk_take_dt[l_row].stk_code, ":", ma_stk_take_dt[l_row].count_qty
        NEXT FIELD NEXT

      ON ACTION next
        CALL DIALOG.appendRow("stk_take")
        LET l_row = ma_stk_take_dt.getLength()
        CALL DIALOG.setCurrentRow("stk_take", l_row)
        NEXT FIELD stk_code
    END INPUT
    ON ACTION CLOSE
      EXIT DIALOG
    ON ACTION QUIT
      EXIT DIALOG
  END DIALOG
  DISPLAY "Rows:", ma_stk_take_dt.getLength()
  CLOSE WINDOW stk_take_input
END FUNCTION
