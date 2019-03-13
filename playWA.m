%% play "whitealbum"
function y = playWA()
global WA;
if length(WA) < 5;
    rhythmpiano = getpianomusicscore();   
    rhythmpiano= [rhythmpiano(1:2,:);rhythmpiano(3,:)*60/100];
    y1 = generaterhythm(rhythmpiano, 0, 1); 
    
    rhythmsax = getsaxmusicscore();    
    rhythmsax= [rhythmsax(1:2,:);rhythmsax(3,:)*60/100];
    y2 = generaterhythm(rhythmsax, 4, 2); 

    rhythmdrum = getdrummusicscore();
    rhythmdrum= [rhythmdrum(1:2,:);rhythmdrum(3,:)*60/100];
    y3 = generaterhythm(rhythmdrum, 8, 3);
    
    rhythmorgan = getorganmusicscore();
    rhythmorgan= [rhythmorgan(1:2,:);rhythmorgan(3,:)*60/100];
    y4 = generaterhythm(rhythmorgan, 0, 4);
    
    WA=y1+y2+2*y3+0.6*y4;
   %plot(lxg)
    %sound(lxg); % play it!
else
 
end

audiowrite(‘WhiteAlbum.wav',WA,8000);
A='over'

%% generate a piece of rhythm
function y = generaterhythm(rhythm, basetune, instrument) 
fs = 8000;
soundpos = [0 2 4 5 7 9 11 0:12];
y = zeros(1, round(sum(rhythm(3,:))*fs) + 1); % initialize
curpos = 1;
for count = 1 : length(rhythm)
cursoundname = rhythm(1, count);
if cursoundname==0
    curfreq=0;
else
    cursoundpos = soundpos(cursoundname);
    curfreq = 220 * 2 .^ ((cursoundpos + basetune + 3) / 12 + rhythm(2, count));
end
cursound = generatetune(curfreq, rhythm(3, count), fs, instrument);
y(1,curpos:(curpos + length(cursound) - 1)) = cursound;
curpos = curpos + length(cursound);
end
  
%% generate a piece of sound with the frequence of freq
function y = generatetune (freq, time, fs, instrument)
y1 = generatetune2 (freq + 5, time, fs, instrument);
y2 = generatetune2 (freq - 5, time, fs, instrument);
y3 = generatetune2 (freq, time, fs, instrument);
y = (y1 + y2) / 8 + y3 * (3 / 4);
 
%% generate a piece of sound with the frequence of freq
function y = generatetune2 (freq, time, fs, instrument)
timbre = ...
    [1  0.005  0.01  0.00  0.00  0.00     0   0;
     0.7  0.4  0.35   0.3   0.2   0.1   0.1   0.1;
     1    0.2   0.2    0      0     0     0   0;
     1    0.2   0.3    0      0     0     0    0];
t = 0:1/fs:(time - 1/fs);
y = zeros(1, length(t));
for j = 1 : 8
    y = y +timbre(instrument,j) * sin(t*j*freq*2*pi);
end
for count1 = 1 : length(y)
    y(1, count1) = y(1, count1) * amendment(count1 / 2000, instrument);
end
 
%% amendment of the shape of the wave
function y = amendment(p, instrument) % 0 <= p <= 1
if(instrument==1||instrument==4)
       if p < 0.05
           y = p * 5;
        elseif p < 0.075
            y = 1.8 - p * 4;
       else
            y = 0.6 * exp((0.3 - p)/5);
       end
end
if(instrument==2)
    if p < 0.1
        y = p*5;
    else 
        y=-0.5*exp(-0.1*p+0.01);
    end
end
if(instrument==3)
    if p < 0.05
        y = p*10;
    elseif p < 0.1
        y=(--10)*p+1;
    else
        y=0;
    end
end
     
function y=getpianomusicscore()
    rhythmpiano1 = ...
[ 4   5   6   3   1   2   1   3   4   5   6   3   1   6   2   2   1   3   4   5   6   3   1   6   2   1   3   4   5   6   3   1   6   2   2   3   3;
  0   0   0   1   1   1   1   0   0   0   0   1   1   0   1   1   1   0   0   0   0   1   1   0   1   1   0   0   0   0   1   1   0   1   1   1   0;
 0.5 0.5 0.5 1.5  1  1.5  2  0.5 0.5 0.5 0.5  1  1  0.5 0.75 0.75 2  0.5 0.5 0.5 0.5  1   1  0.5 1.5  2  0.5 0.5 0.5 0.5  1   1  0.5 0.75 0.75 2 0.5;];
    rhythmpiano2 = ...
[ 4   5   6   3   1   6   2   1   1   2   3   1   6   5   6   6   3   1   2   6   5   3   2   1   2   3     4   3   4    3    2   1   3   6;
  0   0   0   1   1   0   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0     0   0   0    0    0   0   0   0;
 0.5 0.5 0.5  1   1  0.5 1.5  1  0.5 0.5  2   2  0.5 3.5 0.5  1  0.5 0.25 1.75 0.5 1 0.5 0.25 1.25 0.5 0.5 0.5 0.25 0.75 0.5 0.75 0.75 4 0.5];
    rhythmpiano3 = ...
[ 6   3   1   2   2   6     5   5   3   2   1   3     4   5   3   2   3   1   5   5   4   3   4   5   6   1   1   5   5   4   3   4   5   1;
  0   0   0   0   0   0     0   0   0   0   0   0     0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
  1 0.5 0.25 1.25 0.5 0.5  0.5 0.5 0.5 0.25 1.75 0.5 1.5 0.5  1   1  3.5 0.5  2   1   1 0.5 0.25 0.75 0.5 1.5 0.5 2   1   1  0.5 0.25 2.25 1]; 
    rhythmpiano4 = ...
[5   5   4   3   4   5   6   1   1   18   18   16   5   4   5   3   4   5   6   3   1   7   1   2   1   3   4   5   6   3   1   6   2   2   3   3;
 0   0   0   0   0   0   0   1   1    0    0    0   0   0   0   0   0   0   0   1   1   0   1   1   1   0   0   0   0   1   1   0   1   1   1   0;
 2   1   1  0.5 0.5 0.5  2   1  0.5  0.5  0.5  0.5 0.5 0.5  4  0.5 0.5 0.5 0.5 1.5  1  0.5 0.5 0.5  2  0.5 0.5 0.5 0.5  1   1  0.5 0.75 0.75 2  0.5];
    rhythmpiano5 = ...
[4   5   6   3   1   7   1   2   1   1   2   3   6   1   7   1   2   3   4   5   6   3   1   7   1   2   1   3   4   5   6   3   1   6   2   2   3   3;
 0   0   0   1   1   0   1   1   1   1   1   1   0   1   0   1   1   0   0   0   0   1   1   0   1   1   1   0   0   0   0   1   1   0   1   1   1   0;
0.5 0.5 0.5 1.5  1  0.5 0.5 0.5  1  0.5 0.5  4  0.5  1   1  0.5  1  0.5 0.5 0.5 0.5 1.5  1  0.5 0.5 0.5  2  0.5 0.5 0.5 0.5  1   1  0.5 0.75 0.75 2 0.5]; 
   rhythmpiano6 = ...
[4   5   6   3   1   7   1   2   1   1   2   3   6   4   3   1   2   1   6   6   3   1   2   6   5   3   2   1   2   3     4   3     4   3   2   1   3   6;
 0   0   0   1   1   0   1   1   1   1   1   1   0   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0     0   0     0   0   0   0   0   0;
0.5 0.5 0.5 1.5  1  0.5 0.5 0.5  1  0.5 0.5  4  0.5  1   1  0.5  1  16  0.5  1  0.5 0.25 1.75 0.5 1 0.5 0.25 1.25 0.5 0.5 0.5 0.25 0.75 0.5 0.75 0.75 4 0.5]; 
    rhythmpiano7 = [rhythmpiano3, rhythmpiano4, rhythmpiano5] ;    
    rhythmpiano8 = ...
[4   5   6   3   1   7   1   2   1   1   2   3   6   4   3   1   2   1   3   4   5   6   3   1   7   1   2   1   3   4   5   6   3   1   6   2   2   3   3;
 0   0   0   1   1   0   1   1   1   1   1   1   0   1   1   1   1   1   0   0   0   0   1   1   0   1   1   1   0   0   0   0   1   1   0   1   1   1   0;
0.5 0.5 0.5 1.5  1  0.5 0.5 0.5  1  0.5 0.5  4  0.5  1   1  0.5  1  32  0.5 0.5 0.5 0.5 1.5  1  0.5 0.5 0.5  2  0.5 0.5 0.5 0.5  1   1  0.5 0.75 0.75 2 0.5];  
    rhythmpiano9 = ...
[4   5   6   3   1   7   1   2   1   1   2   3   6   4   3   1   2   1;
 0   0   0   1   1   0   1   1   1   1   1   1   0   1   1   1   1   1;
 0.5 0.5 0.5 1.5 1  0.5 0.5 0.5  1  0.5  0.5 4  0.5  1   1  0.5  1  40.5];
    y = [rhythmpiano1,rhythmpiano2,rhythmpiano3,rhythmpiano4,rhythmpiano5,rhythmpiano6,rhythmpiano7,rhythmpiano8,rhythmpiano5, rhythmpiano9];

function y=getsaxmusicscore()
    rhythmsax1 = ...
[0      1    5     7    1    2    7   5    3    7   5    6    5;
 1      1    1     0    1    1    0   0    0    0   0    0    0;
319.5 0.5  10.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.5 0.25  6]; 
    rhythmsax2=...
[5     6    1    3    4    5    6    3   4    5    4   3   4   5   6   1   7   1   2;
 0     0    0    0    0    0    0    1   1    0    0   0   0   0   0   1   0   1   1;  
0.25 0.25 0.25 0.25 0.25  0.25 0.25 0.25 4.75 0.25 0.25 0.5 0.5 0.5 0.5 1  1   1   8];
   rhythmsax3=...
 [0    1     6;
  0    0     0;
 56.5 0.25 0.25];
   rhythmsax4=...
[5    1    1    6   5   1   1   2    3   3   2    1    6    5   1    1   6   5   1    1    2    1    7   5   3   6   6;
 0    0    0    0   0   0   0   0    0   0   0    0    0    0   0    0   0   0   0    0    1    1    0   0   0   0   0;
0.5 0.25 0.75 0.5 0.5 0.25 2.25 0.5 0.5 0.5 0.25 0.75 0.5 0.5 0.25 0.75 0.5 0.5 0.25 1.75 0.25 0.75 0.5 0.5 0.5 0.75 0.25];
   rhythmsax5=...
[5   1    1    6   5   1    1     3   3    4   3    2    1    7    1    6   7   1   2   3    2   3    4    5    6    7    1  7  2  1   7   1   7;
 0   0    0    0   0   0    0     0   0    0   0    0    0    -1   0   -1  -1   0   0   0    0   0    0    0    0    0    1  0  1  1   0   1   0;
0.5 0.25 0.75 0.5 0.5 0.25 1.25  0.5 0.5 0.25 0.25 0.25 1.75 0.25 0.25 0.5 0.5 0.5 0.5 0.5 0.25 0.25 0.25 0.25 0.25 0.25  1  1  1  1 0.25 0.25 7.5];
y=[rhythmsax1,rhythmsax2,rhythmsax3,rhythmsax4,rhythmsax5];

function y=getdrummusicscore()
rhythmdrum1=...
[1    4     1    1    4;
 -3   -3   -3    -3   -3 ;  
 1    0.75  0.75  0.5  1];
rhythmdrum=repmat(rhythmdrum1',114,1);
y=rhythmdrum';

function y=getorganmusicscore()
rhythmorgan1 = ...
[0    3   4   5   6   3   1   6   2   1   3   4   5   6   3   1   6   2   2   3   3;
 0    0   0   0   0   1   1   0   1   1   0   0   0   0   1   1   0   1   1   1   0;
15.5 0.5 0.5 0.5 0.5  1   1  0.5 1.5  2  0.5 0.5 0.5 0.5  1   1  0.5 0.75 0.75 2 0.5;];
rhythmorgan2 = ...
[ 4   5   6   3   1   6   2   1   1   2   3   1   6   5   0   5   5   6   6   0;
  0   0   0   1   1   0   1   1   1   1   1   1   0   0   0   0   0   0   0   0;
 0.5 0.5 0.5  1   1  0.5 1.5  1  0.5 0.5  2   2  0.5  4  60   1   1  0.5 0.5  33];
rhythmorgan3 = ...
[0   3   4    5   6    3    1    6    2    2    1   1    2   3    1   6    5   0   0;
 0   0   0    0   0    1    1    0    1    1    1   1    1   1    1   0    0   0   0;
31.5 0.5 0.5 0.5 0.5   1    1   0.5   1   0.5   1  0.5  0.5  2    2  0.5   4  112 152];
y=[rhythmorgan1,rhythmorgan2,rhythmorgan3];
