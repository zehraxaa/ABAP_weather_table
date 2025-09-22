*&---------------------------------------------------------------------*
*& Report ZZA_WEATHER_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZZA_WEATHER_TABLE.

INCLUDE ZZA_WEATHER_TABLE_TOP.
INCLUDE ZZA_WEATHER_TABLE_F01.


START-OF-SELECTION.
IF p_month LT 1 OR p_month GT 12 OR p_year LT 1582.
  MESSAGE 'Enter a valid year/month.' TYPE 'I' DISPLAY LIKE 'E'.
ELSE.
  PERFORM main.
ENDIF.

END-OF-SELECTION.