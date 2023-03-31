/* Query 1 - The 10 Tracks Feature The Most in Playlists */
SELECT Track.Name,
       COUNT(PlaylistTrack.PlaylistId) "# Playlists"
FROM Track
JOIN PlaylistTrack ON Track.TrackId = PlaylistTrack.TrackId
GROUP BY Track.Name
ORDER BY "# Playlists" DESC
LIMIT 10;

-----------------------
/* Query 2 - What Is The Best Selling Genres */
SELECT Genre.Name,
       SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) Earnings
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Genre.Name
ORDER BY Earnings DESC
LIMIT 10;

-- FOR CALCULATING THE AVERAGE --
WITH t1 AS
  (SELECT Genre.Name,
          SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) Earnings
   FROM Genre
   JOIN Track ON Genre.GenreId = Track.GenreId
   JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
   GROUP BY Genre.Name
   ORDER BY Earnings DESC)
SELECT AVG(t1.Earnings)
FROM T1;

-----------------------
/* Query 3 - The 3 Best Selling Genres Performance Throughout The Years */ 
WITH T2 AS
  (WITH T1 AS
     (SELECT Genre.Name,
             SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) Earnings
      FROM Genre
      JOIN Track ON Genre.GenreId = Track.GenreId
      JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
      GROUP BY Genre.Name
      ORDER BY Earnings DESC
      LIMIT 3) SELECT Genre.Name,
                      strftime('%Y', Invoice.InvoiceDate) YEAR,
                                                          SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) Earnings
   FROM Genre
   JOIN Track ON Genre.GenreId =Track.GenreId
   JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
   JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
   WHERE Genre.Name in
       (SELECT T1.Name
        FROM T1)
   GROUP BY Genre.Name,
            YEAR
   ORDER BY YEAR)
SELECT T2.Name,
       AVG(CASE
               WHEN T2.Year = "2009" THEN T2.Earnings
           END) AS "2009",
       AVG(CASE
               WHEN T2.Year = "2010" THEN T2.Earnings
           END) AS "2010",
       AVG(CASE
               WHEN T2.Year = "2011" THEN T2.Earnings
           END) AS "2011",
       AVG(CASE
               WHEN T2.Year = "2012" THEN T2.Earnings
           END) AS "2012",
       AVG(CASE
               WHEN T2.Year = "2013" THEN T2.Earnings
           END) AS "2013"
FROM T2
GROUP BY T2.Name;

/* Since there is no Pivot function in SQLITE I had to hardcode this functionality thanks to https://stackoverflow.com/a/21999845 */
/* I would really appreciate if there is a better way to get the same result, or to imporve this query ,please help.*/

----------------------
/* Query 4 - The Length Of The Track And It's Effect On Quantity Sold */
SELECT Track.Milliseconds/1000 Track_in_Seconds,
       SUM(InvoiceLine.Quantity) Quantity_Sold
FROM Track
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Milliseconds
ORDER BY Track_in_Seconds