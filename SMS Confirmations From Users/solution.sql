-- Solution in PostgreSQl

-- step - 1 : filter out the type = 'confirmation' and type = 'friend_request'
-- step - 2 : filter date, ds = 2020-08-04
-- step - 3 : LEFT JOIN by phone number and ds
-- step - 4 : Calculate the ratio of COUNT(phone_number from fb_confirmers) / COUNT(fb_sms_sends) :: float * 100, converting to float and multiplying by 100 for final result
SELECT COUNT(fc.phone_number)/COUNT(fss.phone_number)::float * 100 AS percentage
FROM fb_sms_sends AS fss
LEFT JOIN fb_confirmers AS fc
ON fss.phone_number = fc.phone_number AND 
   fss.ds = fc.date
WHERE fss.ds = '2020-08-04'
AND fss.type NOT IN ('confirmation', 'friend_request');
