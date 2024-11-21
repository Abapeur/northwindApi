CLASS ztest_crt_proxy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES : if_rap_query_provider.

  PROTECTED SECTION.

  METHODS : get_comment
  IMPORTING id type i
    RETURNING VALUE(rv_comments) TYPE string.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztest_crt_proxy IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).
    data(filter) = io_request->get_filter( ).

    DATA:
      ls_entity_key    TYPE ztest_northwind=>tys_alphabetical_list_of_produ,
      ls_business_data TYPE ztest_northwind=>tys_alphabetical_list_of_produ,
      lt_business_data TYPE TABLE OF ztest_northwind=>tys_alphabetical_list_of_produ,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy.



    TRY.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( 'https://services.odata.org' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZTEST_NORTHWIND'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/v2/northwind/northwind.svc' ).

        ASSERT lo_http_client IS BOUND.

        DATA: lo_read_list_request    TYPE REF TO /iwbep/if_cp_request_read_list,
              lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
              lo_read_list_response   TYPE REF TO /iwbep/if_cp_response_read_lst.

        lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'PRODUCTS' ).
        lo_read_list_request = lo_entity_list_resource->create_request_for_read( ).
        lo_read_list_response = lo_read_list_request->execute( ).
        lo_read_list_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).

        RAISE SHORTDUMP lx_web_http_client_error.

    ENDTRY.

    TYPES : tty_products TYPE STANDARD TABLE OF ztest_cust_northwind WITH EMPTY KEY.


    DATA(lt_data) = VALUE tty_products(
      FOR ls_data IN lt_business_data
      ( product_id = ls_data-product_id
        category_id = ls_data-category_id
        product_name = ls_data-product_name
        quantity_per_unit = ls_data-quantity_per_unit
        supplier_id = ls_data-supplier_id
        unit_price = ls_data-unit_price
        units_on_order = ls_data-units_on_order
        comment_product = me->get_comment( ls_data-product_id ) )
    ).
    data(lt_range) = filter->get_as_ranges( ).
    if lt_range IS NOT INITIAL.
        data(lv_product_id) = lt_range[ 1 ]-range[ 1 ]-low.
        DELETE lt_data WHERE product_id <> lv_product_id.
    ENDIF.
    io_response->set_total_number_of_records( lines( lt_data  ) ).
    io_response->set_data( lt_data ).

  ENDMETHOD.

  METHOD get_comment.
SELECT SINGLE comment_product FROM ztest_prod WHERE product_id = @id INTO @DATA(lv_comment).
    rv_comments = lv_comment.
  ENDMETHOD.

ENDCLASS.
