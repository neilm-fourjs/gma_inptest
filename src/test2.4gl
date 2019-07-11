
TYPE t_rec RECORD
		txt CHAR(10),
		val INTEGER
	END RECORD
DEFINE m_arr DYNAMIC ARRAY OF t_rec
DEFINE m_rec t_rec
----------------------------------------------------------------------------------------------------
FUNCTION test2()
	OPEN FORM f FROM "test2"
	DISPLAY FORM f
	DIALOG ATTRIBUTES(UNBUFFERED)
		INPUT BY NAME m_rec.* ATTRIBUTES(WITHOUT DEFAULTS)
			AFTER INPUT
				IF m_rec.txt IS NOT NULL THEN
					IF NOT int_flag THEN
						LET m_arr[ m_arr.getLength() + 1 ].* = m_rec.*
					END IF	
					INITIALIZE m_rec TO NULL
					NEXT FIELD txt
				END IF

			ON ACTION scan_barcode
				LET m_rec.txt = "ABCD"||m_arr.getLength()
				LET m_rec.val = 1

			ON ACTION next
				CALL DIALOG.accept()
		END INPUT
		DISPLAY ARRAY m_arr TO s_arr.*
			ON UPDATE ATTRIBUTES(TEXT=%"Update Row", IMAGE="fa-ellipsis-v")
				INPUT m_arr[ arr_curr() ].* FROM txt,val ATTRIBUTES(WITHOUT DEFAULTS)
		END DISPLAY
		ON ACTION close EXIT DIALOG
		ON ACTION quit EXIT DIALOG
	END DIALOG
END FUNCTION
