CLASS lhc_ZTEST_CUST_NORTHWIND DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_buffer,
              pid        TYPE abp_behv_pid,
              product_ID TYPE ztest_cust_northwind_order-product_ID,
              order_id   TYPE ztest_cust_northwind_order-order_id,
              quantity   TYPE ztest_cust_northwind_order-quantity,
            END OF ty_buffer,
            BEGIN OF ty_buffer_prod,
              pid             TYPE abp_behv_pid,
              product_ID      TYPE ztest_cust_northwind-product_ID,
              comment_product TYPE ztest_cust_northwind-comment_product,
            END OF ty_buffer_prod.
    CLASS-DATA : mt_buffer_create TYPE STANDARD TABLE OF ty_buffer WITH EMPTY KEY.
    CLASS-DATA : mt_buffer_update TYPE STANDARD TABLE OF ty_buffer WITH EMPTY KEY.
    CLASS-DATA : mt_buffer_delete TYPE STANDARD TABLE OF ty_buffer WITH EMPTY KEY.
    CLASS-DATA : mt_buffer_upd_prod TYPE STANDARD TABLE OF ty_buffer_prod WITH EMPTY KEY.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztest_cust_northwind RESULT result.

    METHODS rba_Orders FOR READ
      IMPORTING keys_rba FOR READ ztest_cust_northwind\Orders FULL result_requested RESULT result LINK association_links.

    METHODS cba_Orders FOR MODIFY
      IMPORTING entities_cba FOR CREATE ztest_cust_northwind\Orders.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ztest_cust_northwind.

ENDCLASS.

CLASS lhc_ZTEST_CUST_NORTHWIND IMPLEMENTATION.

  METHOD read.

* To implement

  ENDMETHOD.

  METHOD rba_Orders.

* To implement

  ENDMETHOD.

  METHOD cba_Orders.
    DATA n TYPE i VALUE 1.

    LOOP AT entities_cba INTO DATA(ls_entity).
      LOOP AT ls_entity-%target INTO DATA(ls_target).

        APPEND VALUE #(
         pid = n
         product_id = ls_target-product_id
         quantity = ls_target-quantity
        ) TO lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_create.

        APPEND VALUE #(
        %cid = ls_target-%cid
        %pid = n
        product_id = ls_target-product_id ) TO mapped-ztest_cust_northwind_order.
        n = n + 1.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      APPEND VALUE #(
       product_id = ls_entity-product_id
       comment_product = ls_entity-comment_product
      ) TO lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_upd_prod.

      APPEND VALUE #(
      product_id = ls_entity-product_id ) TO mapped-ztest_cust_northwind.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZTEST_CUST_NORTHWIND_ORDER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    DATA : lt_buffer TYPE TABLE OF ztest_order.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ztest_cust_northwind_order.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ztest_cust_northwind_order.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztest_cust_northwind_order RESULT result.

    METHODS rba_Product FOR READ
      IMPORTING keys_rba FOR READ ztest_cust_northwind_order\_Product FULL result_requested RESULT result LINK association_links.


ENDCLASS.

CLASS lhc_ZTEST_CUST_NORTHWIND_ORDER IMPLEMENTATION.

  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      APPEND VALUE #(
       pid = ls_entity-%pid
       product_id = ls_entity-product_id
       order_id = ls_entity-order_id
       quantity = ls_entity-quantity
      ) TO lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_update.

      APPEND VALUE #(
      product_id = ls_entity-product_id
      order_id = ls_entity-order_id ) TO mapped-ztest_cust_northwind_order.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #(
       product_id = ls_key-product_id
       order_id = ls_key-order_id
      ) TO lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_delete.

      APPEND VALUE #(
      product_id = ls_key-product_id
      order_id = ls_key-order_id ) TO mapped-ztest_cust_northwind_order.
    ENDLOOP.
  ENDMETHOD.


  METHOD read.

    DATA : orders TYPE TABLE OF ztest_order.

    LOOP AT keys INTO DATA(ls_key).

      SELECT SINGLE * FROM ztest_order
      WHERE product_id = @ls_key-product_id AND order_id = @ls_key-order_id
      INTO @DATA(ls_result).

      IF sy-subrc <> 0.
        READ TABLE lt_buffer INTO ls_result WITH KEY product_id = ls_key-product_id order_id = ls_key-order_id.
      ENDIF.

      IF ls_result IS NOT INITIAL.
        APPEND CORRESPONDING #( ls_result MAPPING TO ENTITY ) TO result.
      ENDIF.

    ENDLOOP.

    IF result IS INITIAL.
      APPEND VALUE #(
      product_id = ls_key-product_id
      order_id = ls_key-order_id
      %fail-cause = if_abap_behv=>cause-not_found ) TO failed-ztest_cust_northwind_order.


    ENDIF.

  ENDMETHOD.

  METHOD rba_Product.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZTEST_CUST_NORTHWIND DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.
    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_ZTEST_CUST_NORTHWIND IMPLEMENTATION.

  METHOD finalize.

* To implement

  ENDMETHOD.

  METHOD check_before_save.

* To implement

  ENDMETHOD.

  METHOD save.

    LOOP AT lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_create INTO DATA(ls_buffer_create).
      DATA(ls_data) = VALUE ztest_order( product_id = ls_buffer_create-product_id order_id = ls_buffer_create-order_id quantity = ls_buffer_create-quantity ).
      MODIFY ztest_order FROM @ls_data.
    ENDLOOP.

    LOOP AT lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_update INTO DATA(ls_buffer_update).
      ls_data = VALUE ztest_order( product_id = ls_buffer_update-product_id order_id = ls_buffer_update-order_id quantity = ls_buffer_update-quantity ).
      MODIFY ztest_order FROM @ls_data.
    ENDLOOP.

    LOOP AT lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_delete INTO DATA(ls_buffer_delete).
      DATA(ls_key) = VALUE ztest_order( product_id = ls_buffer_delete-product_id order_id = ls_buffer_delete-order_id ).
      DELETE ztest_order FROM @ls_key.
    ENDLOOP.

    LOOP AT lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_upd_prod INTO DATA(ls_buffer_upd_prod).
      DATA(ls_data_prod) = VALUE ztest_prod( product_id = ls_buffer_upd_prod-product_id comment_product =  ls_buffer_upd_prod-comment_product ).
      MODIFY ztest_prod FROM @ls_data_prod.
    ENDLOOP.

  ENDMETHOD.

  METHOD cleanup.

* To implement

  ENDMETHOD.

  METHOD cleanup_finalize.

* To implement

  ENDMETHOD.

  METHOD adjust_numbers.

    LOOP AT lhc_ZTEST_CUST_NORTHWIND=>mt_buffer_create ASSIGNING FIELD-SYMBOL(<ls_buffer>).

      SELECT MAX( order_id )
        FROM ztest_cust_northwind_order
        WHERE product_id = @<ls_buffer>-product_id
        INTO @DATA(lv_orderid).

      lv_orderid = lv_orderid + 1.

      APPEND VALUE #(
      %pid = <ls_buffer>-pid
      %tmp = VALUE #( product_id = <ls_buffer>-product_id )
      product_id = <ls_buffer>-product_id
      order_id = lv_orderid ) TO mapped-ztest_cust_northwind_order.

      <ls_buffer>-order_id = lv_orderid.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
