*&---------------------------------------------------------------------*
*& Include ZZA_WEATHER_TABLE_F01
*&---------------------------------------------------------------------*

FORM main.
  PERFORM get_data.
  PERFORM def_season.
  PERFORM temperature_maker.
  PERFORM fill_table_date_temp.
  PERFORM weekend_form.
  PERFORM list.
 ENDFORM.

"FORM = VERİLERİ AL"
FORM get_data.
lv_month = p_month.
lv_year = p_year.

CONCATENATE lv_year lv_month '01' INTO lv_date. "kullanıcının girdiği değeri yyyymmmdd formatında aldım

CALL FUNCTION 'NUMBER_OF_DAYS_PER_MONTH_GET' "verilen tarihin bulunduğu ayın son gününü hesaplıyo"
EXPORTING
  par_month = lv_month
  par_year = lv_year
IMPORTING
  par_days = lv_last_day. "ayın gün sayısı. last day zaten toplam gün sayısıdır

ENDFORM.

"FORM = TABLOYU DOLDUR"
FORM fill_table_date_temp.
  lv_day = 01.
  lv_p_tempr = 0.

 DO lv_last_day TIMES.
   lv_temp_date = lv_date.
   lv_day_str = lv_day.
   lv_temp_date+6(2) = lv_day_str.
   gs_weather-full_date = |{ lv_temp_date+6(2) }.{ lv_temp_date+4(2) }.{ lv_temp_date(4) }|.

   PERFORM temperature_maker.
   gs_weather-tempr = lv_temprature.

   APPEND gs_weather TO gt_weather.
   lv_p_tempr = lv_temprature.
   lv_day = lv_day + 1.
 ENDDO.
 ENDFORM.

"FORM = MEVSİM BELİRLE
FORM def_season.
  CASE lv_month.
    WHEN '03' OR '04' OR '05'.
      lv_min_tempr = 8.
      lv_max_tempr = 25.

    WHEN '06' OR '07' OR '08'.
      lv_min_tempr = 25.
      lv_max_tempr = 45.

    WHEN '09'.
      lv_min_tempr = 12.
      lv_max_tempr = 29.

    WHEN '10' OR '11'.
      lv_min_tempr = 10.
      lv_max_tempr = 20.

    WHEN '12' OR '01' OR '02'.
      lv_min_tempr = -10.
      lv_max_tempr = 10.
ENDCASE.
  ENDFORM.

"FORM = SICAKLIK_ÜRET
FORM temperature_maker.
  IF lv_day EQ 1.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
     EXPORTING
        ran_int_min = lv_min_tempr
        ran_int_max = lv_max_tempr
     IMPORTING
         ran_int = lv_temprature.
  ELSE.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
          ran_int_min = lv_p_tempr - 5
          ran_int_max = lv_p_tempr + 5
      IMPORTING
          ran_int = lv_temprature.
  ENDIF.
  IF lv_temprature GT lv_max_tempr. "eğer üstüne ekleye ekleye max sınırı aştıysa max sınırın dışına çıkmasına izin vermiyor.
    lv_temprature = lv_max_tempr.
  ENDIF.
  IF lv_temprature LT lv_min_tempr. "min değerin altına düştüyse geri sınıra çekiyoruz
    lv_temprature = lv_min_tempr.
  ENDIF.
  lv_p_tempr = lv_temprature.
ENDFORM.

"FORM = WEEKEND_FORM
FORM weekend_form.
  lv_day = 1.
  WHILE lv_day <= lv_last_day.
    lv_temp_date2 = lv_date. "YYYYMMDD"
    lv_day_str = lv_day. "17 (str)"
    lv_temp_date2+6(2) = lv_day_str.                                    "YYYYMMDD düzeninde DD değerini değiştiriyoruz. YYYYMM17 oluyor"

    CALL FUNCTION 'DAY_IN_WEEK'
      EXPORTING
        datum = lv_temp_date2
      IMPORTING
        wotnr = lv_weekday.
    IF lv_weekday = 6 OR lv_weekday = 7.
      READ TABLE gt_weather INTO gs_weather INDEX lv_day.
      IF sy-subrc = 0.
        gs_weather_weekend = gs_weather.
        APPEND gs_weather_weekend TO gt_weather_weekend.
      ENDIF.
    ENDIF.
    lv_day = lv_day + 1.
  ENDWHILE.
ENDFORM.

FORM list.
  cl_demo_output=>display( gt_weather ).
  cl_demo_output=>display( gt_weather_weekend ).
  ENDFORM.