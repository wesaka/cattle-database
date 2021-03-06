CREATE TABLE `3815023_wes`.`cattle`
(
    `UID`              INT        NOT NULL AUTO_INCREMENT,
    `date_born`        DATE       NOT NULL,
    `weight_birth`     DECIMAL(0) NULL,
    `parent_1`         INT        NULL,
    `parent_2`         INT        NULL,
    `date_bought`      DATE       NULL,
    `weight_received`  DATE       NULL,
    `price_bought`     DECIMAL(0) NULL,
    `last_weight`      DECIMAL(0) NULL,
    `date_last_weight` DATE       NULL,
    `price_sold`       DECIMAL(0) NULL,
    `date_sold`        DATE       NULL,
    `tag`              INT        NOT NULL,
    `owner`            INT        NOT NULL,
    PRIMARY KEY (`UID`)
) ENGINE = InnoDB
  CHARSET = utf8
  COLLATE utf8_unicode_ci;