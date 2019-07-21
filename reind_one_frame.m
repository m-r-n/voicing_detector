% -------------------------------------------------------------
%                             Reindexing of one frame
%
% This code is based on the following conference papers:
% [1] M. Kepesi, L. Weruaga, E. Schofield: Detailed Multidimensional Analysis of our Acoustical Environment,” 
%     Forum Acusticum. Budapest (Hu), September 2005, pp. 2649-2654.
% [2] M. Kepesi and L. Weruaga: High-resolution noise-robust spectral-based pitch estimation,” 
%     Interspeech 2005, pp. 313-316, Lisboa (P), Sep. 2005
% See also https://signalprocessingideas.wordpress.com/2008/12/07/spectral-reindexing-for-pitch-estimation/
%         contact: mrn-at-post in cz
% -------------------------------------------------------------

function sumReind = reind_one_frame(inputFrame, Fs, Nfft, minF0, maxF0, LUT1, LUT2,plotThisFrame)

% -------------------------------------------------------------
% ------------- 	Spectrum of the frame -----------------------
% -------------------------------------------------------------

freqPerBin = Fs/Nfft;

spZ1=20*log (0.0001+ abs(fft(inputFrame, Nfft)));

if plotThisFrame
    figure 100
    subplot(212);
    plot(spZ1(1:400));grid
    xlabel("freq.bin index")
    title(["logSpectr, Hz/Bin: ", num2str(freqPerBin)])
  end
% -------------------------------------------------------------
% ---------------- reindexing LUT preparaion ------------------
% -------------------------------------------------------------
% for the LUTs, call "create_reind_LUTs.m"

% -------------------------------------------------------------
% ---------------- reindexing NOW -----------------------------
% -------------------------------------------------------------
% positive Spectral components
reindSpec1 = spZ1(LUT1(1, :));
reindSpec2 = spZ1(LUT1(2, :));
reindSpec3 = spZ1(LUT1(3, :));
reindSpec4 = spZ1(LUT1(4, :));
reindSpec5 = spZ1(LUT1(5, :));

% negative Spectral components
reindSpec1n = spZ1(LUT2(1, :));
reindSpec2n = spZ1(LUT2(2, :));
reindSpec3n = spZ1(LUT2(3, :));
reindSpec4n = spZ1(LUT2(4, :));
reindSpec5n = spZ1(LUT2(5, :));

% ---- fast Reindexing ----
sumReindPlus = reindSpec1 + reindSpec2 + reindSpec3 + reindSpec4 + reindSpec5;
sumReindMinus = reindSpec1n + reindSpec2n + reindSpec3n + reindSpec4n + reindSpec5n;
sumReind = sumReindPlus - sumReindMinus;

% -------------------------------------------------------------
% ---------------- Plotting----------------- ------------------
% -------------------------------------------------------------

if plotThisFrame,
    figure 101; clf;
    subplot(211)
    hold on; 
    plot(reindSpec1,'r')
    plot(reindSpec2,'b')
    plot(reindSpec3,'c')
    plot(reindSpec4,'k')
    plot(reindSpec5,'r')

    plot(reindSpec1n,'r-.')
    plot(reindSpec2n,'b-.')
    plot(reindSpec3n,'c-.')
    plot(reindSpec4n,'k-.')
    plot(reindSpec5n,'r-.')
    grid on;
    xlabel(["f0-", num2str(minF0), "[Hz]"])
    ylabel("lo-spectral enery")

    figure 101; 
    subplot(212); hold on
    title(["Reind +/-(red/black) an final (blue)freqPerBin: ", num2str(freqPerBin)]);
    xlabel (["f0-", num2str(minF0), "[Hz]"])
    plot(sumReindPlus, 'r')
    plot(sumReindMinus, 'k')
    plot(sumReind, 'b')
    grid
    end;


