
IMPORT FGL test1
IMPORT FGL test2

MAIN
	MENU
		COMMAND "Test1"
			CALL test1.test1()
			DISPLAY "Finish test1"
		COMMAND "Test2"
			CALL test2.test2()
			DISPLAY "Finish test2"
		ON ACTION quit EXIT MENU
		ON ACTION close EXIT MENU
	END MENU
END MAIN
