function level = otsu(histogramCounts)
total = sum(histogramCounts); % '''total''' is the number of pixels in the given image. 
%% OTSU automatic thresholding method
sumB = 0;
wB = 0;
maximum = 0.0;
sum1 = dot( (0:255), histogramCounts); 
for ii=1:256
    wB = wB + histogramCounts(ii);
    wF = total - wB;
    if (wB == 0 || wF == 0)
        continue;
    end
    sumB = sumB +  (ii-1) * histogramCounts(ii);
    mF = (sum1 - sumB) / wF;
    between = wB * wF * ((sumB / wB) - mF) * ((sumB / wB) - mF);
    if ( between >= maximum )
        level = ii;
        maximum = between;
    end
end
end