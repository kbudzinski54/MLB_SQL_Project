-- Turn off safe updates for bulk edits
SET SQL_SAFE_UPDATES = 0;

-- Create the teams table
CREATE TABLE teams (
    yearID INT,
    lgID VARCHAR(10),
    teamID VARCHAR(10),
    divID VARCHAR(10),
    `Rank` INT,
    G INT,
    Ghome INT,
    W INT,
    L INT,
    DivWin VARCHAR(1),
    WCWin VARCHAR(1),
    LgWin VARCHAR(1),
    WSWin VARCHAR(1),
    R INT,
    AB INT,
    H INT,
    `2B` INT,
    `3B` INT,
    HR INT,
    BB INT,
    SO INT,
    SB INT,
    CS INT,
    HBP INT,
    SF INT,
    RA INT,
    ER INT,
    ERA FLOAT,
    CG INT,
    SHO INT,
    SV INT,
    IPouts INT,
    HA INT,
    HRA INT,
    BBA INT,
    SOA INT,
    E INT,
    DP INT,
    FP FLOAT,
    name VARCHAR(100),
    park VARCHAR(100),
    attendance INT,
    BPF INT,
    PPF INT,
    teamIDBR VARCHAR(10),
    teamIDlahman45 VARCHAR(10),
    teamIDretro VARCHAR(10)
);

-- Load data into teams table
LOAD DATA LOCAL INFILE '/Users/kevinbudzinski/Desktop/SQL Project/Teams.csv'
INTO TABLE teams
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Remove header row if accidentally imported
DELETE FROM teams
WHERE teamID = 'teamID';

-- Clean team names in payrolls table
-- Remove non-breaking spaces (UTF-8 bytes C2 A0)
UPDATE payrolls
SET team = REPLACE(REPLACE(team, CHAR(194), ''), CHAR(160), '');

-- Or for utf8mb4 safer replacement:
UPDATE payrolls
SET team = REPLACE(team, CONVERT(0xC2A0 USING utf8mb4), '');

-- Remove normal spaces
UPDATE payrolls
SET team = REPLACE(team, ' ', '');

-- Trim leading/trailing whitespace
UPDATE payrolls
SET team = TRIM(team);

-- Uppercase everything
UPDATE payrolls
SET team = UPPER(team);

-- Turn safe updates back on
SET SQL_SAFE_UPDATES = 1;

-- Check cleaned team names
SELECT DISTINCT team, LENGTH(team), HEX(team)
FROM payrolls
ORDER BY team;
