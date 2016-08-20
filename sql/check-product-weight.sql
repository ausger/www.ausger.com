select ped.* from eav_attribute AS ea, eav_entity_type eet, catalog_product_entity_decimal AS ped
where ea.entity_type_id = eet.entity_type_id and eet.entity_type_code = 'catalog_product' and ea.attribute_code = 'weight'
and ped.entity_type_id = eet.entity_type_id and ped.value is NULL and ped.attribute_id = ea.attribute_id;