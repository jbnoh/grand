-- CREATE DEFINER='usr_grand'@'59.10.109.75' FUNCTION get_typeCheck (
DELIMITER $$
CREATE DEFINER='root'@'127.0.0.1' FUNCTION get_typeCheck (
   val_type    varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci,
   val_01      varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci,
   val_02      varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci) RETURNS varchar(20) CHARSET utf8
    DETERMINISTIC
BEGIN
   DECLARE rltValue   VARCHAR(50);
   SET rltValue = 'noImage';

   IF val_type = 'extension'
   THEN
      IF val_01 = 'jpg'
      THEN
         SET rltValue = 'image';
      ELSEIF val_01 = 'png'
      THEN
         SET rltValue = 'image';
      ELSEIF val_01 = 'gif'
      THEN
         SET rltValue = 'image';
      ELSEIF val_01 = 'jpeg'
      THEN
         SET rltValue = 'image';
      ELSE
         SET rltValue = 'noImage';
      END IF;
   END IF;

   RETURN rltValue;
END $$

-- CREATE DEFINER='usr_grand'@'59.10.109.75' FUNCTION SHA2 (message MEDIUMBLOB, bits SMALLINT) RETURNS char(64) CHARSET utf8
DELIMITER $$
CREATE DEFINER='root'@'127.0.0.1' FUNCTION SHA2 (message MEDIUMBLOB, bits SMALLINT) RETURNS char(64) CHARSET utf8
    DETERMINISTIC
BEGIN
    DECLARE k, w BLOB;
    DECLARE a, b, c, d, e, f, g, h, h0, h1, h2, h3, h4, h5, h6, h7, wn, s0, s1, maj, ch, t1, t2, i,
            messagelen, npaddingbits, len, ppmessagelen, numchunks, currentchunk INT UNSIGNED;
    DECLARE modvalue BIGINT UNSIGNED DEFAULT 0x00000000FFFFFFFF;
    DECLARE ppmessage, chunk MEDIUMBLOB;



    -- SHA2 constants
    SET k = UNHEX('428A2F9871374491B5C0FBCFE9B5DBA53956C25B59F111F1923F82A4AB1C5ED5D807'
                  'AA9812835B01243185BE550C7DC372BE5D7480DEB1FE9BDC06A7C19BF174E49B69C1'
                  'EFBE47860FC19DC6240CA1CC2DE92C6F4A7484AA5CB0A9DC76F988DA983E5152A831'
                  'C66DB00327C8BF597FC7C6E00BF3D5A7914706CA63511429296727B70A852E1B2138'
                  '4D2C6DFC53380D13650A7354766A0ABB81C2C92E92722C85A2BFE8A1A81A664BC24B'
                  '8B70C76C51A3D192E819D6990624F40E3585106AA07019A4C1161E376C082748774C'
                  '34B0BCB5391C0CB34ED8AA4A5B9CCA4F682E6FF3748F82EE78A5636F84C878148CC7'
                  '020890BEFFFAA4506CEBBEF9A3F7C67178F2');
    SET h0 = 0x6a09e667, h1 = 0xbb67ae85, h2 = 0x3c6ef372, h3 = 0xa54ff53a, h4 = 0x510e527f,
        h5 = 0x9b05688c, h6 = 0x1f83d9ab, h7 = 0x5be0cd19;

    SET messagelen = LENGTH(message) * 8, npaddingbits = 8;
    WHILE ((messagelen + npaddingbits) % 512) != 448 DO
        SET npaddingbits = npaddingbits + 8;
    END WHILE;

    SET ppmessage = CONCAT(message, CHAR(0x80), REPEAT(CHAR(0x00), (npaddingbits - 8) / 8),
                           UNHEX(LPAD(HEX(messagelen), 16, '0')));
    SET ppmessagelen = LENGTH(ppmessage) * 8;
    SET numchunks = ppmessagelen >> 9, currentchunk = 1;

    REPEAT
        SET chunk = SUBSTRING(ppmessage FROM ((currentchunk - 1) * 64) + 1 FOR 64);
        SET a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, h = h7, i = 0;

        SET w = chunk;
        WHILE i < 64 DO
            IF i > 15 THEN
                SET wn = ARRAY_GET(w, i - 15), s0 = ROR32(wn,  7) ^ ROR32(wn, 18) ^ (wn >>  3),
                    wn = ARRAY_GET(w, i -  2), s1 = ROR32(wn, 17) ^ ROR32(wn, 19) ^ (wn >> 10),
                    wn = (ARRAY_GET(w, i - 16) + s0 + ARRAY_GET(w, i - 7) + s1) & modvalue,
                    w = CONCAT(w, CHAR(wn >> 24, (wn & 0x00FF0000) >> 16, (wn & 0x0000FF00) >> 8,
                               wn & 0x000000FF));
            ELSE
                SET wn = ARRAY_GET(w, i);
            END IF;

            SET s0 = ROR32(a, 2) ^ ROR32(a, 13) ^ ROR32(a, 22), maj = (a & b) ^ (a & c) ^ (b & c),
                t2 = (s0 + maj) & modvalue,
                s1 = ROR32(e, 6) ^ ROR32(e, 11) ^ ROR32(e, 25), ch = (e & f) ^ ((~e) & g),
                t1 = (h + s1 + ch + ARRAY_GET(k, i) + wn) & modvalue,
                h = g, g = f, f = e, e = (d + t1) & modvalue, d = c, c = b, b = a,
                a = (t1 + t2) & modvalue,
                i = i + 1;
        END WHILE;

        SET h0 = (h0 + a) & modvalue, h1 = (h1 + b) & modvalue, h2 = (h2 + c) & modvalue,
            h3 = (h3 + d) & modvalue, h4 = (h4 + e) & modvalue, h5 = (h5 + f) & modvalue,
            h6 = (h6 + g) & modvalue, h7 = (h7 + h) & modvalue,
            currentchunk = currentchunk + 1;
    UNTIL currentchunk > numchunks
    END REPEAT;

    RETURN LOWER(CONCAT(LPAD(HEX(h0), 8, '0'), LPAD(HEX(h1), 8, '0'), LPAD(HEX(h2), 8, '0'), LPAD(HEX(h3), 8, '0'), LPAD(HEX(h4), 8, '0'), LPAD(HEX(h5), 8, '0'), LPAD(HEX(h6), 8, '0'), LPAD(HEX(h7), 8, '0')));
END $$
