% Vibrationa of a Square Plate 
clc
clear all
close all

model = createpde('structural' , 'modal-solid') % creating the structural model 

importGeometry(model , 'Plate10x10x1.stl') % import and define the geometry 

figure(1)
hc = pdegplot(model , 'FaceLabels' , 'on' ) % defining the face labels and plotting the geometry
hc(1).FaceAlpha = 0.25 % face labels is required to define the B.C.
title('Plate with Face Labels' , 'FontSize' , 12)

structuralProperties(model , 'YoungsModulus' , 200e9 , ...
                           'PoissonsRatio', 0.3 , ...
                           'MassDensity' , 8000) % mechanical properties 

structuralBC(model , 'Face' , 1 : 4 , 'ZDisplacement' , 0) % considering zero displacements in the z-direction as B.C.
% corresponding edge faces are 1 through 4

%generateMesh(model, 'Hmin' , 1.3) % generate the mesh 
generateMesh(model, 'Hmax' , 1.3) % generate the mesh 
figure(2) 
pdeplot3D(model)
title('Mesh with Quadratic Tetrahedral Elements' , 'FontSize' , 12)

% For comparison with the published values, load the reference frequencies in Hz.
refFreqHz = [0 0 0 45.897 109.44 109.44 167.89 193.59 206.19 206.19] % comparison with benchmark values 

maxFreq = 1.1 * refFreqHz(end) * 2 * pi 
result = solve(model , 'FrequencyRange' , [-0.1 maxFreq]) % solve the problem for a range of frequencies 


freqHz = result.NaturalFrequencies / (2 * pi) % convert frequencies from rad/sec to Hz
% Compare the reference and computed frequencies (in Hz) for the lowest 10 modes. 
% The lowest three mode shapes correspond to rigid-body motion of the plate. 
% Their frequencies are close to zero.

tfreqHz = table(refFreqHz.' , freqHz(1:10))
tfreqHz.Properties.VariableNames = {'Reference','Computed'}
disp(tfreqHz)

% Plot the third component (z-component) of the solution for the seven lowest nonzero-frequency modes.
h = figure(3)
h.Position = [100,100,900,600]
numToPrint = min(length(freqHz) , length(refFreqHz))

for i = 4 : numToPrint
    subplot(4 , 2 , i-3)
    pdeplot3D(model , 'ColorMapData' , result.ModeShapes.uz(: , i) )
    axis equal
    title(sprintf( [ 'Mode=%d, z-displacement\n', ...
    'Frequency(Hz): Ref=%g FEM=%g' ] , ...
    i , refFreqHz(i) , freqHz(i)))
end



h = figure(4)
%h.Position = [100,100,900,600]
% numToPrint = min(length(freqHz) , length(refFreqHz))
N2 = 5
for i = 4 : N2
    subplot(1 , 2 , i-3)
    pdeplot3D(model , 'ColorMapData' , result.ModeShapes.uz(: , i) )
    axis equal
    title(sprintf( [ ' Mode=%d , z-displacement\n ', ...
    ' Frequency(Hz): Ref=%g FEM=%g ' ] , ...
    i , refFreqHz(i) , freqHz(i)))
end





