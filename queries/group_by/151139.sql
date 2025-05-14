-- 코드를 입력하세요
SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(*) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE START_DATE BETWEEN DATE '2022-08-01' AND DATE '2022-10-31'
    AND CAR_ID IN (SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
                WHERE START_DATE BETWEEN DATE '2022-08-01' AND DATE '2022-10-31'
                GROUP BY CAR_ID
                HAVING COUNT(*) > 4)
GROUP BY 
    EXTRACT(MONTH FROM START_DATE)
    , CAR_ID
ORDER BY 
    MONTH ASC,
    CAR_ID DESC;


-- 내가 적은 해설
-- -- #4. #3에서 묶은 행들에서 START_DATE의 월, CAR_ID, 그리고 해당 열과 CAR_ID에 해당하는 숫자 합계를 가져오기
-- SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(*) AS RECORDS
-- FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
--     -- #2. #1에 해당하는 CAR_ID들 중에서 마찬가지로 '2022-08-01' 와 '2022-10-31' 사이의 START_DATE를 가진 행만 대상으로
-- WHERE START_DATE BETWEEN DATE '2022-08-01' AND DATE '2022-10-31'
--         -- #1. '2022-08-01' 와 '2022-10-31' 사이의 START_DATE 를 가진 CAR_ID중, 카운트가 5개 이상인 것
--     AND CAR_ID IN (SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
--                 WHERE START_DATE BETWEEN DATE '2022-08-01' AND DATE '2022-10-31'
--                 GROUP BY CAR_ID
--                 HAVING COUNT(*) > 4)
-- -- #3. #2에 해당하는 행을 START_DATE의 month 기준으로, 그리고 CAR_ID 기준으로 묶고
-- GROUP BY 
--     EXTRACT(MONTH FROM START_DATE)
--     , CAR_ID
-- -- #5. #4에서 가져온 결과를 정렬 MONTH와 CAR_ID로 정렬
-- ORDER BY 
--     MONTH ASC,
--     CAR_ID DESC;


-- ChatGPT가 적은 해설
-- -- #4. #3에서 묶은 행들에서 START_DATE의 월, CAR_ID, 그리고 해당 열과 CAR_ID에 해당하는 숫자 합계를 가져오기
-- SELECT 
--     EXTRACT(MONTH FROM START_DATE) AS MONTH,  -- 월 추출
--     CAR_ID,
--     COUNT(*) AS RECORDS  -- 대여 횟수
-- FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
--     -- #2. #1에 해당하는 CAR_ID들 중에서 마찬가지로 '2022-08-01' 와 '2022-10-31' 사이의 START_DATE를 가진 행만 대상으로
-- WHERE START_DATE BETWEEN DATE '2022-08-01' AND DATE '2022-10-31'
--     -- #1. '2022-08-01' 와 '2022-10-31' 사이의 START_DATE 를 가진 CAR_ID 중, 카운트가 5개 이상인 것
--     AND CAR_ID IN (
--         SELECT CAR_ID
--         FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
--         WHERE START_DATE BETWEEN DATE '2022-08-01' AND DATE '2022-10-31'
--         GROUP BY CAR_ID
--         HAVING COUNT(*) >= 5
--     )
-- -- #3. #2에 해당하는 행을 START_DATE의 month 기준으로, 그리고 CAR_ID 기준으로 묶고
-- GROUP BY 
--     EXTRACT(MONTH FROM START_DATE), 
--     CAR_ID
-- -- #5. #4에서 가져온 결과를 정렬 MONTH와 CAR_ID로 정렬
-- ORDER BY 
--     MONTH ASC,
--     CAR_ID DESC;




-- 문제 설명
-- 다음은 어느 자동차 대여 회사의 자동차 대여 기록 정보를 담은 CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블입니다. CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블은 아래와 같은 구조로 되어있으며, HISTORY_ID, CAR_ID, START_DATE, END_DATE 는 각각 자동차 대여 기록 ID, 자동차 ID, 대여 시작일, 대여 종료일을 나타냅니다.

-- Column name	Type	Nullable
-- HISTORY_ID	INTEGER	FALSE
-- CAR_ID	INTEGER	FALSE
-- START_DATE	DATE	FALSE
-- END_DATE	DATE	FALSE
-- 문제
-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 대여 시작일을 기준으로 2022년 8월부터 2022년 10월까지 총 대여 횟수가 5회 이상인 자동차들에 대해서 해당 기간 동안의 월별 자동차 ID 별 총 대여 횟수(컬럼명: RECORDS) 리스트를 출력하는 SQL문을 작성해주세요. 결과는 월을 기준으로 오름차순 정렬하고, 월이 같다면 자동차 ID를 기준으로 내림차순 정렬해주세요. 특정 월의 총 대여 횟수가 0인 경우에는 결과에서 제외해주세요.

-- 예시
-- 예를 들어 CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블이 다음과 같다면

-- HISTORY_ID	CAR_ID	START_DATE	END_DATE
-- 1	1	2022-07-27	2022-08-02
-- 2	1	2022-08-03	2022-08-04
-- 3	2	2022-08-05	2022-08-05
-- 4	2	2022-08-09	2022-08-12
-- 5	3	2022-09-16	2022-10-15
-- 6	1	2022-08-24	2022-08-30
-- 7	3	2022-10-16	2022-10-19
-- 8	1	2022-09-03	2022-09-07
-- 9	1	2022-09-18	2022-09-19
-- 10	2	2022-09-08	2022-09-10
-- 11	2	2022-10-16	2022-10-19
-- 12	1	2022-09-29	2022-10-06
-- 13	2	2022-10-30	2022-11-01
-- 14	2	2022-11-05	2022-11-05
-- 15	3	2022-11-11	2022-11-11
-- 대여 시작일을 기준으로 총 대여 횟수가 5회 이상인 자동차는 자동차 ID가 1, 2인 자동차입니다. 월 별 자동차 ID별 총 대여 횟수를 구하고 월 오름차순, 자동차 ID 내림차순으로 정렬하면 다음과 같이 나와야 합니다.

-- MONTH	CAR_ID	RECORDS
-- 8	2	2
-- 8	1	2
-- 9	2	1
-- 9	1	3
-- 10	2	2