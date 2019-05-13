tic
image=imread('forged2.png');

grayimage = rgb2gray(image);

R=size(grayimage,1);
C=size(grayimage,2);

B=8;

block=zeros(8);
satir=1;
Vects = zeros((R-7)*(C-7),18);
Vect=zeros(1,64);
h = 1 ;
for a=1:R-7
    for b=1:C-7
      
       for m=1:8
           for n=1:8    
              block(m,n) = grayimage(a+m-1,b+n-1);
           end
       end
       
       dct1 = dct2(block);
       dct_ = floor(dct1/18);
       
       [~,N]=size(dct_);
        
        Vect(1)=dct_(1,1);
        v=1;
        for k=1:2*N-1
            if k<=N
                if mod(k,2)==0
                j=k;
                for i=1:k
                    Vect(v)=dct_(i,j);
                    v=v+1;
                    j=j-1;
                end
                else
                    i=k;
                    for j=1:k   
                        Vect(v)=dct_(i,j);
                        v=v+1;
                        i=i-1;       
                    end
                end
            else
                if mod(k,2)==0
                   p=mod(k,N);
                   j=N;
                    for i=p+1:N
                        Vect(v)=dct_(i,j);
                        v=v+1;
                        j=j-1;      
                    end
            else
                   p=mod(k,N);
                   i=N;
                   for j=p+1:N   
                       Vect(v)=dct_(i,j);
                       v=v+1;
                       i=i-1;                       
                   end
               end
            end
        end
        for s = 1 : 16
           Vects(h,s) = Vect(s);
        end
        Vects(h,s+1)=a;
        Vects(h,s+2)=b;
        h = h + 1 ;
    end
end

Vects=sortrows(Vects,1:16);
count = 1;
resim = imread('black.png');
for i=1:(R-7)*(C-7) - 25
    for j=i+1:i+ 25
        sum = 0 ;
        for m=1:16
            sum = sum + (Vects(i,m) - Vects(j,m)).^2;
            dist = sqrt(sum); 
        end
        if dist < 0.5
         a=sqrt((Vects(i,17)-Vects(j,17))^2 + (Vects(i,18)-Vects(j,18))^2 );
         if a > 61
             Vects2(count,1)=Vects(i,17);
             Vects2(count,2)=Vects(i,18);
             Vects2(count,3)=Vects(j,17);
             Vects2(count,4)=Vects(j,18);
             Vects2(count,5)=abs(Vects(i,17)-Vects(j,17));
             Vects2(count,6)=abs(Vects(i,18)-Vects(j,18));
             
             aa=Vects2(count,3);
             bb=Vects2(count,4);
             cc=Vects2(count,1);
             dd=Vects2(count,2);  
             for k=1:8
                 for l=1:8
                        resim(aa-1+k,bb-1+l,1)=255;
                        resim(cc-1+k,dd-1+l,1)=255;
                        resim(aa-1+k,bb-1+l,2)=255;
                        resim(cc-1+k,dd-1+l,2)=255;
                        resim(aa-1+k,bb-1+l,3)=255;
                        resim(cc-1+k,dd-1+l,3)=255;      
                 end 
             end
             count=count+1 ;
         end     
     end
    end 
end
toc
imshow(resim);
maske=imread('maske2.png');
t=getFmeasure(resim,maske);
