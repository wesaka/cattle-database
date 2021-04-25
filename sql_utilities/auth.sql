DELIMITER $$
CREATE FUNCTION auth(
    uname VARCHAR(25),
    pword VARCHAR(25)
)
    RETURNS TINYINT(1)
BEGIN
    DECLARE userExists TINYINT(1) DEFAULT 0;
    DECLARE passwordCheck TINYINT(1) DEFAULT 0;
    # Check if user exists
    SELECT COUNT(username) INTO userExists FROM owners WHERE username = uname;

    # If not, create
    IF userExists = 0 THEN
        INSERT INTO owners(username, password) VALUES (uname, pword);
        RETURN 1;
    ELSE
        #However, if it exists, check if the password is equal, if so, return true, if not, return false
        SELECT password = pword INTO passwordCheck FROM owners WHERE username = uname;
        IF passwordCheck = 1 THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END IF;
END $$