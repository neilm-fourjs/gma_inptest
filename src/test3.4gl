TYPE t_rec RECORD
  txt CHAR(10),
  val INTEGER
END RECORD
DEFINE m_arr DYNAMIC ARRAY OF t_rec
----------------------------------------------------------------------------------------------------
FUNCTION test()
  DEFINE l_row SMALLINT
  OPEN FORM f FROM "test3"
  DISPLAY FORM f
  INPUT ARRAY m_arr FROM s_arr.* ATTRIBUTES(WITHOUT DEFAULTS, UNBUFFERED)
    BEFORE ROW
      LET l_row = arr_curr()
      DISPLAY "BR:", l_row

    AFTER ROW
			DISPLAY SFMT("AR %1 : %2 = %3", l_row, DIALOG.getCurrentItem(), NVL(m_arr[l_row].txt, "NULL"))

		BEFORE FIELD txt
			DISPLAY SFMT("BF %1 : %2 = %3 (%4)",
					l_row,
					DIALOG.getCurrentItem(),
					NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
          NVL(m_arr[l_row].txt, "NULL"))

		BEFORE FIELD val
			DISPLAY SFMT("BF %1 : %2 = %3 (%4)",
					l_row,
					DIALOG.getCurrentItem(),
					NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
          NVL(m_arr[l_row].val, "NULL"))

		AFTER FIELD txt
			DISPLAY SFMT("AF %1 : %2 = %3 (%4)",
					l_row,
					DIALOG.getCurrentItem(),
					NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
          NVL(m_arr[l_row].txt, "NULL"))

		AFTER FIELD val
			DISPLAY SFMT("AF %1 : %2 = %3 (%4)",
					l_row,
					DIALOG.getCurrentItem(),
					NVL(DIALOG.getFieldValue(DIALOG.getCurrentItem()), "NULL"),
          NVL(m_arr[l_row].val, "NULL"))

    ON ACTION scan_barcode
      LET m_arr[l_row].txt = "ABCD" || m_arr.getLength()
      LET m_arr[l_row].val = 1
      NEXT FIELD NEXT

    ON ACTION NEXT
      CALL DIALOG.appendRow("s_arr")
      LET l_row = m_arr.getLength()
      CALL DIALOG.setCurrentRow("s_arr", l_row)
      NEXT FIELD txt

    ON ACTION close
      EXIT INPUT
    ON ACTION quit
      EXIT INPUT
  END INPUT
END FUNCTION
