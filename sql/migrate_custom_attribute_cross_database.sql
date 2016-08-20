-- This script is used to migrate customized attributes of drop-down/select type and global scope from existing database to a new database.
-- sql command format is as follows
--  INSERT INTO db1.table1
-- SELECT *
--   FROM db2.table2 t2
--   WHERE ...

-- 1. migrate eav_attribute
insert into www_ausger_com_a.eav_attribute
select * from mage_ausger_de.eav_attribute as ea
where ea.attribute_code = 'brand' OR ea.attribute_code = 'age_range' OR ea.attribute_code = 'aptamil_code' OR ea.attribute_code = 'bottle_volume'

-- 2. migrate eav_attribute_option
  -- 2.1 for attribute 'brand'
         insert into www_ausger_com_a.eav_attribute_option
         select eao.* from mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute as ea
         where eao.attribute_id = ea.attribute_id AND ea.attribute_code = 'brand'
  -- 2.2 for attribute age_range
         insert into www_ausger_com_a.eav_attribute_option
         select eao.* from mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute as ea
         where eao.attribute_id = ea.attribute_id AND ea.attribute_code = 'age_range'
  -- 2.3 for attribute  aptamil_code
         insert into www_ausger_com_a.eav_attribute_option
         select eao.* from mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute as ea
         where eao.attribute_id = ea.attribute_id AND ea.attribute_code = 'aptamil_code'
  -- 2.4 for attribute  bottle_volume
         insert into www_ausger_com_a.eav_attribute_option
         select eao.* from mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute as ea
         where eao.attribute_id = ea.attribute_id AND ea.attribute_code = 'bottle_volume'

-- 3. migrate eav_attribute_option_value
  -- 3.1 for attribute 'brand'
  insert into www_ausger_com_a.eav_attribute_option_value
select eov.value_id, eov.option_id, eov.store_id, eov.value  from mage_ausger_de.eav_attribute as ea, mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute_option_value as eov
where ea.attribute_code = 'brand' AND ea.attribute_id = eao.attribute_id AND eao.option_id = eov.option_id
  -- 3.2 for attribute 'age_range'
insert into www_ausger_com_a.eav_attribute_option_value select eov.value_id, eov.option_id, eov.store_id, eov.value from mage_ausger_de.eav_attribute as ea, mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute_option_value as eov where ea.attribute_code = 'age_range' AND ea.attribute_id = eao.attribute_id AND eao.option_id = eov.option_id
  -- 4945,4947,4950,4953,4956,4959,4962,4965,4968,4970,4973,4976,4978,4981,4984,4987,4990,4992,4996,4999,5002,5005,5009,5012,5015,5018,5021,5024,5028,5031,5034,5036,5040,5043
  -- 3.3 for attribute 'aptamil_code'
insert into www_ausger_com_a.eav_attribute_option_value select eov.value_id, eov.option_id, eov.store_id, eov.value from mage_ausger_de.eav_attribute as ea, mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute_option_value as eov where ea.attribute_code = 'aptamil_code' AND ea.attribute_id = eao.attribute_id AND eao.option_id = eov.option_id
  -- 3.4 for attribute 'bottle_volume'
insert into www_ausger_com_a.eav_attribute_option_value select eov.value_id, eov.option_id, eov.store_id, eov.value from mage_ausger_de.eav_attribute as ea, mage_ausger_de.eav_attribute_option as eao, mage_ausger_de.eav_attribute_option_value as eov where ea.attribute_code = 'bottle_volume' AND ea.attribute_id = eao.attribute_id AND eao.option_id = eov.option_id

-- 4. migrate eav_attribute_attribute from mage_ausger_de schema to www_ausger_com_a
-- all drop-down (of select type) attributes like "brand,age_range,aptamil_code,bottle_volume" in mage_ausger_de were assigned to different attribute set and attribute_group
-- in the new schema www_ausger_com_a, they will be copy to the out-of-box attribute_set 'Default' and attribute_group 'General'.
-- attribute_set 'Default' has id 4, attribute_group 'General' has id 7.
-- 4.1 migrate brand
insert into www_ausger_com_a.eav_entity_attribute (entity_attribute_id, entity_type_id, attribute_set_id, attribute_group_id, attribute_id, sort_order) select NULL, 4, 4, 7, mage_ausger_de.eav_entity_attribute.attribute_id, mage_ausger_de.eav_entity_attribute.sort_order from  mage_ausger_de.eav_entity_attribute, mage_ausger_de.eav_attribute where mage_ausger_de.eav_entity_attribute.attribute_id = mage_ausger_de.eav_attribute.attribute_id and mage_ausger_de.eav_attribute.attribute_code = 'brand'
-- or with following command
insert into www_ausger_com_a.eav_entity_attribute (entity_attribute_id, entity_type_id, attribute_set_id, attribute_group_id, attribute_id, sort_order) select NULL, 4, mage_ausger_de.eav_entity_attribute.attribute_set_id, mage_ausger_de.eav_entity_attribute.attribute_group_id, mage_ausger_de.eav_entity_attribute.attribute_id, mage_ausger_de.eav_entity_attribute.sort_order from  mage_ausger_de.eav_entity_attribute, mage_ausger_de.eav_attribute where mage_ausger_de.eav_entity_attribute.attribute_id = mage_ausger_de.eav_attribute.attribute_id and mage_ausger_de.eav_attribute.attribute_code = 'brand' and mage_ausger_de.eav_entity_attribute.attribute_set_id=4 and mage_ausger_de.eav_entity_attribute.attribute_group_id = 7

-- 4.2 migrate aptamil_code
insert into www_ausger_com_a.eav_entity_attribute (entity_attribute_id, entity_type_id, attribute_set_id, attribute_group_id, attribute_id, sort_order) select NULL, 4, 4, 7, mage_ausger_de.eav_entity_attribute.attribute_id, mage_ausger_de.eav_entity_attribute.sort_order from mage_ausger_de.eav_entity_attribute, mage_ausger_de.eav_attribute where mage_ausger_de.eav_entity_attribute.attribute_id = mage_ausger_de.eav_attribute.attribute_id and mage_ausger_de.eav_attribute.attribute_code = 'aptamil_code'
-- 4.3 migrate bottle_volume
insert into www_ausger_com_a.eav_entity_attribute (entity_attribute_id, entity_type_id, attribute_set_id, attribute_group_id, attribute_id, sort_order) select NULL, 4, mage_ausger_de.eav_entity_attribute.attribute_set_id, mage_ausger_de.eav_entity_attribute.attribute_group_id, mage_ausger_de.eav_entity_attribute.attribute_id, mage_ausger_de.eav_entity_attribute.sort_order from  mage_ausger_de.eav_entity_attribute, mage_ausger_de.eav_attribute where mage_ausger_de.eav_entity_attribute.attribute_id = mage_ausger_de.eav_attribute.attribute_id and mage_ausger_de.eav_attribute.attribute_code = 'bottle_volume' and mage_ausger_de.eav_entity_attribute.attribute_set_id=4 and mage_ausger_de.eav_entity_attribute.attribute_group_id = 7
-- 4.4 migrate age_range is save as above

-- 5. migrate catalog_eav_attribute for drop-down (select type) attributes.
-- 5.1 brand
insert into www_ausger_com_a.catalog_eav_attribute (attribute_id,frontend_input_renderer,is_global,is_visible,is_searchable,is_filterable,is_comparable,	is_visible_on_front,is_html_allowed_on_front,is_used_for_price_rules,is_filterable_in_search,used_in_product_listing,used_for_sort_by,is_configurable,apply_to,is_visible_in_advanced_search,position,is_wysiwyg_enabled,is_used_for_promo_rules) SELECT mage_ausger_de.catalog_eav_attribute.attribute_id,mage_ausger_de.catalog_eav_attribute.frontend_input_renderer,mage_ausger_de.catalog_eav_attribute.is_global,mage_ausger_de.catalog_eav_attribute.is_visible,mage_ausger_de.catalog_eav_attribute.is_searchable,mage_ausger_de.catalog_eav_attribute.is_filterable,mage_ausger_de.catalog_eav_attribute.is_comparable,mage_ausger_de.catalog_eav_attribute.is_visible_on_front,mage_ausger_de.catalog_eav_attribute.is_html_allowed_on_front,mage_ausger_de.catalog_eav_attribute.is_used_for_price_rules,mage_ausger_de.catalog_eav_attribute.is_filterable_in_search,mage_ausger_de.catalog_eav_attribute.used_in_product_listing,mage_ausger_de.catalog_eav_attribute.used_for_sort_by,mage_ausger_de.catalog_eav_attribute.is_configurable,mage_ausger_de.catalog_eav_attribute.apply_to,mage_ausger_de.catalog_eav_attribute.is_visible_in_advanced_search,mage_ausger_de.catalog_eav_attribute.position,mage_ausger_de.catalog_eav_attribute.is_wysiwyg_enabled,mage_ausger_de.catalog_eav_attribute.is_used_for_promo_rules FROM mage_ausger_de.catalog_eav_attribute, mage_ausger_de.eav_attribute WHERE mage_ausger_de.eav_attribute.attribute_id = mage_ausger_de.catalog_eav_attribute.attribute_id and  mage_ausger_de.eav_attribute.attribute_code='brand'

-- 6. CLEAN UP multiple store imported issue of option value for the attribute 'age_range'
-- delete the following results
SELECT * FROM eav_attribute_option_value WHERE value like '%Jahr%'
SELECT * FROM eav_attribute_option_value WHERE value like '%Monat%'
