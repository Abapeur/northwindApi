@EndUserText.label: 'test custom CDS Northwind'
@ObjectModel.query.implementedBy: 'ABAP:ZTEST_CRT_PROXY'
@UI.headerInfo: { typeName: 'Product', typeNamePlural: 'Products', title: { type: #STANDARD, value: 'product_id' }, description.value : 'product_name' }
define root custom entity ZTEST_CUST_NORTHWIND 
{ 
@UI.facet: [
{ id: 'Product', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, position: 10 },
{ id: 'Order', purpose: #STANDARD, type: #LINEITEM_REFERENCE, label: 'Orders', position: 20, targetElement: 'orders'  }
]
@UI.lineItem: [{ position: 10 }]
@UI.identification: [{ position: 10 }]
@EndUserText.label: 'Product ID'
  key   product_id : int4;
@UI.lineItem: [{ position: 20 }]
@UI.identification: [{ position: 20 }]
@EndUserText.label: 'Product Name'
        product_name : abap.char( 100 );
@UI.lineItem: [{ position: 30 }]  
@UI.identification: [{ position: 30 }]      
@EndUserText.label: 'Supplier ID'
        supplier_id : int4;
@UI.lineItem: [{ position: 40 }]
@UI.identification: [{ position: 40 }]
@EndUserText.label: 'Category ID'
        category_id : int4;
@UI.lineItem: [{ position: 50 }]
@UI.identification: [{ position: 50 }]
@EndUserText.label: 'Quantity Per Unit'
        quantity_per_unit : abap.char( 100 );
@UI.lineItem: [{ position: 60 }]
@UI.identification: [{ position: 60 }]
@EndUserText.label: 'Unit Price'
        unit_price : abap.dec( 16, 0 );
@UI.lineItem: [{ position: 70}]
@UI.identification: [{ position: 70 }]
@EndUserText.label: 'Units In Stock'
        units_in_stock : int2;
@UI.lineItem: [{ position: 80, label: 'Units On Order' }]
@UI.identification: [{ position: 80 }]
@EndUserText.label: 'Units On Order'
        units_on_order : int2; 
@UI.lineItem: [{ position: 90, label: 'Comment' }]
@UI.identification: [{ position: 90 }]
@EndUserText.label: 'Comment'
        comment_product : abap.char(100);               
        orders : composition [0..*] of ZTEST_CUST_NORTHWIND_ORDER;
}
