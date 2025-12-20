-- 00_schema.sql

-- Event calendar that will provide details to our data source
CREATE OR REPLACE TABLE LKP_EVENTS_CALENDAR (
  EVENT_TYPE            VARCHAR(),
  EVENT_DATE            DATE(),
  SEASON                VARCHAR(),
  EVENT_START_TIME      TIMESTAMP(),
  DAY_OF_WEEK           VARCHAR(),
  EVENT_NAME            VARCHAR(),
  EVENT_GENRE           VARCHAR(),
  EVENT_TIER            VARCHAR(),
  GENERAL_ATTENDANCE    NUMBER(),
  CLUB_ATTENDANCE       NUMBER(),
  SUITE_ATTENDANCE      NUMBER(),
  COURTSIDE_ATTENDANCE  NUMBER(),
  TOTAL_ATTENDANCE      NUMBER()
);

-- Location table with details about each stand
CREATE OR REPLACE TABLE LKP_STAND_LOCATIONS (
  VENDOR_ID    VARCHAR(),
  STAND_NAME   VARCHAR(),
  DEPARTMENT   VARCHAR(),
  STAND_TYPE   VARCHAR(),
  ARENA_LEVEL  VARCHAR()
);

-- Items table with categorizations to disect the sales data further
CREATE OR REPLACE TABLE LKP_ITEM_DETAILS (
  ITEM_NAME        VARCHAR(),
  ITEM_ID          VARCHAR(),
  ITEM_PRICE       FLOAT(),
  ITEM_COST        FLOAT(),
  ITEM_GROUP       VARCHAR(),
  ITEM_CATEGORY    VARCHAR(),
  ITEM_SUBCATEGORY VARCHAR()
);

-- Source of all sales we will analyize
CREATE OR REPLACE TABLE SRC_RAW_SALES_BY_ITEM (
  SALE_ID        VARCHAR(),
  SALE_TIME      TIMESTAMP(),
  ITEM_ID        VARCHAR(),
  ITEM_NAME      VARCHAR(),
  VENDOR_ID      VARCHAR(),
  POS_ID         VARCHAR(),
  EMPLOYEE_ID    VARCHAR(),
  UNITS_SOLD     NUMBER(),
  GROSS_SALES    FLOAT(),
  NET_SALES      FLOAT(),
  DISCOUNTS      FLOAT(),
  DISCOUNT_NAME  VARCHAR()
);
