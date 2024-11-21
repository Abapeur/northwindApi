@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order association product Northwind'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZTEST_CUST_NORTHWIND_ORDER
  as select from ztest_order
  association to parent ZTEST_CUST_NORTHWIND as _Product on $projection.product_id = _Product.product_id
{
      @EndUserText.label: 'Product ID'
      @UI.facet: [ {
        label: 'General Information',
        id: 'GeneralInfo',
        purpose: #STANDARD,
        position: 10 ,
        type: #IDENTIFICATION_REFERENCE
      } ]
      @UI.identification: [ {
        position: 10
      } ]
      @UI.lineItem: [ {
        position: 10
      } ]
      @UI.selectionField: [ {
        position: 10
      } ]
  key product_id,
      @EndUserText.label: 'Order ID'
      @UI.identification: [ {
        position: 20
      } ]
      @UI.lineItem: [ {
        position: 20
      } ]
      @UI.selectionField: [ {
        position: 20
      } ]
  key order_id,
      @EndUserText.label: 'Quantity'
      @UI.identification: [ {
        position: 30
      } ]
      @UI.lineItem: [ {
        position: 30
      } ]
      @UI.selectionField: [ {
        position: 30
      } ]
      quantity,
      _Product
}
