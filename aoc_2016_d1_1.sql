
Declare input string;
set input = 'L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1';
set input  = replace(input,' ','');
  

with RECURSIVE directions as  
(
    select 'N' direction,'W' as L ,'E' R
    union all 
    select 'E' direction,'N' as L ,'S' R
    union all 
    select 'W' direction,'S' as L ,'N' R
    union all 
    select 'S' direction,'E' as L ,'W' R
    
)--select * from cte ;
, inputdirections as (
  select row_number () over () seq, left( hq_path,1 )side,right(hq_path, length(hq_path)-1)steps from unnest(split(input,',')) hq_path 
  
)  
,   resolved_directions as ( 
  select a.*, case when a.side = 'L' then b.L else b.R end direction from inputdirections a  join  directions b on  a.seq=1 and b.direction = 'N'
  union all 
  select a.*,case when a.side = 'L' then c.L else c.R end from inputdirections a join resolved_directions b on a.seq =  b.seq+1 join directions c on c.direction = b.direction 
  )
  , answer as (
  select direction,sum(cast(steps as int64))steps  from resolved_directions group by direction
  )
  select ABS( (select steps from answer where direction = 'W') -  (select steps from answer where direction = 'E') )
            + ABS( (select steps from answer where direction = 'N') -  (select steps from answer where direction = 'S'));
