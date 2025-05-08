Select * from `hospital-quarterly-financial-utilization`;

--  Total Discharges

SELECT TYPE_HOSP, Concat(ROUND(SUM(DIS_TOT) / 1000000, 1),'M')  AS Total_discharges,
COUNT(TYPE_HOSP) AS No_of_hospital,
 Concat(ROUND(SUM(NET_TOT) / 1000000000, 0),'B')  AS Total_Net_Patient_Revenue,
 Concat(ROUND(SUM(DAy_TOT) / 1000000, 1),'M')  AS Total_Patient_Days
FROM `hospital-quarterly-financial-utilization` 
GROUP BY TYPE_HOSP;

--  Patient Days

SELECT 
  `Year`,
 Concat(ROUND(SUM(DAY_TOT) / 1000000, 1),'M') AS `Total_patient_days_in_Millions`
FROM `hospital-quarterly-financial-utilization` 
GROUP BY `Year`;


--  Net Patient Revenue

SELECT 
    FAC_NAME,
    YEAR_QTR,
    NET_PAT_REV_CC
FROM 
   `hospital-quarterly-financial-utilization`
WHERE 
    NET_PAT_REV_CC IS NOT NULL;

SELECT 
    YEAR_QTR,
     Concat(ROUND(SUM(NET_PAT_REV_CC) / 1000000, 2),'M') AS Total_net_patient_revenue
FROM 
`hospital-quarterly-financial-utilization`
GROUP BY 
    YEAR_QTR
ORDER BY 
    YEAR_QTR;
    
--  State wise no. of hospital/revenue

SELECT * FROM healthcare_db.`hospital-quarterly-financial-utilization`;
select city from `hospital-quarterly-financial-utilization`;
select TYPE_HOSP from `hospital-quarterly-financial-utilization`;
select count(*) TYPE_hosp from `hospital-quarterly-financial-utilization`;
SELECT city, COUNT(*) AS TYPE_HOSP 
FROM `hospital-quarterly-financial-utilization`
GROUP BY city ORDER BY TYPE_HOSP DESC;
SELECT 
    city,
    COUNT(*) AS hospital_count,
     Concat(ROUND(SUM(NET_TOT) / 1000000000, 2),'B')  AS total_revenue
FROM 
    `hospital-quarterly-financial-utilization`
GROUP BY 
    city
ORDER BY 
    total_revenue DESC;
    
--  Type of hospital revenue

SELECT TYPE_HOSP,Concat(ROUND(SUM(NET_PAT_REV_CC) / 1000000, 2),'M') As Total_net_patient_revenue
From `hospital-quarterly-financial-utilization`
GROUP BY TYPE_HOSP
ORDER BY total_net_patient_revenue DESC;

--  YTD/QTD

-- YTD CALCULATION: Discharges, Patient Days & Net Revenue
-- This query gives you a running total (YTD) for each hospital, year, and quarter

SELECT 
    a.FAC_NO AS Hospital_ID,
    a.FAC_NAME AS Hospital_Name,
    a.Year,
    a.Quarter,

    -- YTD Discharges (Total up to this quarter)
    Concat(ROUND(SUM(b.DIS_TOT) / 1000, 0),'K') AS YTD_Discharge_Total,

    -- YTD Patient Days
    Concat(ROUND(SUM(b.DAY_TOT) / 1000, 2),'K') AS YTD_Patient_Days,

    -- YTD Net Patient Revenue
    Concat(ROUND(SUM(b.NET_PAT_REV_CC) / 1000000, 2),'M') AS YTD_Net_Patient_Revenue

FROM 
    `hospital-quarterly-financial-utilization` a

-- Join the same table to itself to sum up from Q1 to current Quarter
JOIN 
    `hospital-quarterly-financial-utilization` b
    ON a.FAC_NO = b.FAC_NO
    AND a.Year = b.Year
    AND b.Quarter <= a.Quarter

-- Group results so we get YTD per hospital per quarter
GROUP BY 
    a.FAC_NO, a.FAC_NAME, a.Year, a.Quarter

-- Optional: Order to make results easier to read
ORDER BY 
    a.FAC_NO, a.Year, a.Quarter;
  
  
  
  -- QTD CALCULATION: Discharges, Patient Days & Net Revenue
-- This query gives you data *only* for the selected quarter — no accumulation

SELECT 
    FAC_NO AS Hospital_ID,
    FAC_NAME AS Hospital_Name,
    Year,
    Quarter,

    -- Discharges for the quarter
    DIS_TOT AS QTD_Discharge_Total,

    -- Patient Days for the quarter
    DAY_TOT AS QTD_Patient_Days,

    -- Net Revenue for the quarter
    NET_PAT_REV_CC AS QTD_Net_Patient_Revenue

FROM 
    `hospital-quarterly-financial-utilization`

-- Optional: Order neatly for human eyes
ORDER BY 
    FAC_NO, Year, Quarter;
    
--  Total Patient 

SELECT `YEAR`, Concat(ROUND(SUM(NET_PAT_REV_CC) / 1000000, 2),'M') AS Total_patients
FROM `hospital-quarterly-financial-utilization`
GROUP BY `YEAR`;

-- Total Doctor

SELECT TYPE_HOSP,Concat(ROUND(SUM(PHY_COMP) / 1000000, 0),'M') AS Total_doctors
FROM `hospital-quarterly-financial-utilization`
GROUP BY TYPE_HOSP;

-- Total Hospital

SELECT TYPE_HOSP, COUNT(TYPE_HOSP) AS Total_hospitals
FROM `hospital-quarterly-financial-utilization`
GROUP BY TYPE_HOSP;