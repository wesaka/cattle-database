DELIMITER $$

CREATE TRIGGER update_owner
    AFTER INSERT
    ON sold FOR EACH ROW
BEGIN
    UPDATE cattle SET owner = NEW.buyer_uid WHERE uid = NEW.cattle_uid;
END $$

DELIMITER ;
