*&---------------------------------------------------------------------*
*& Include ZZA_WEATHER_TABLE_TOP
*&---------------------------------------------------------------------*

DATA: lv_last_day TYPE numc2, "ayın son günü"
      lt_dates_table TYPE TABLE OF string, "sonuçları saklayacağımız tablo/liste"
      lv_day TYPE i, "sayac 1 den başlayıp ayın son gününe kadar gidiyor"
      lv_day_str TYPE char2,
      lv_month TYPE numc2,
      lv_year TYPE numc4,
      lv_date TYPE d, "kullanıcının girdiği tarih 'YYYYMMDD'"
      lv_temp_date TYPE d, "döngüde kullanacağız. geçici değer"
      lv_temprature TYPE i,
      lv_tempr_str TYPE char3,
      lv_p_tempr TYPE i, "önceki sıcaklık (previous temperature)"
      lv_min_tempr TYPE i,
      lv_max_tempr TYPE i,
      lv_season TYPE string, "mevsim"
      lt_temprature_table TYPE TABLE OF string,
      lv_weekday TYPE p,
      lv_temp_date2 TYPE d. "weekend için geçici tarih tutucu"

PARAMETERS: p_month TYPE numc2,
            p_year TYPE numc4.

TYPES: BEGIN OF ty_weather,
  full_date TYPE char10, "DD.MM.YYYY formatlanmış tarih stringi"
  tempr TYPE i,
  END OF ty_weather.

DATA: gt_weather TYPE TABLE OF ty_weather,
      gs_weather TYPE ty_weather,
      gt_weather_weekend TYPE TABLE OF ty_weather,
      gs_weather_weekend TYPE ty_weather.

"type d = tarih (date)"
"gt = global table"
"ty= type"
"gs = global structure"