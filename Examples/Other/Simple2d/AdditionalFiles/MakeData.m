% Capture the training error rate information from the log file.
close all
clear all;

fp = fopen('ResNet.log', 'r');
fp2 = fopen('AutoMarkov.log', 'r');

matchWord = 'SamplesPerSecond';
figure;

i = 0;
if fp

    while true
        theLine = fgets(fp);
        if isempty(theLine) || theLine(1) == -1
            break;
        end
        % Look for the message at the end of each epoch.
        if strncmp(theLine, ' Epoch', length(' Epoch'))
            try
                % Pick out the epoch number and training error
                [a,b]  = regexp(theLine,'\d+(\.\d+)?');
                strPos = find(a > strfind(theLine,matchWord),1,'first');
                nValue = str2double(theLine(a(strPos):b(strPos)));
                i=i+1;
                trainingError(i) = nValue;
            catch e
                % Ignore lines we can't read
            end
        end
    end
    fclose(fp);
else
    fprintf('Can not find the demo training log\n');
end


for i=1:size(trainingError, 2)
    avgTrainingError1(i) = sum(trainingError(1:i))/i;
end
 
plot(trainingError, 'g')

i = 0;
if fp2
    while true
        theLine = fgets(fp2);
        if isempty(theLine) || theLine(1) == -1
            break;
        end
        % Look for the message at the end of each epoch.
        if strncmp(theLine, ' Epoch', length(' Epoch'))
            try
                % Pick out the epoch number and training error

                [a,b]  = regexp(theLine,'\d+(\.\d+)?');
                strPos = find(a > strfind(theLine,matchWord),1,'first');
                nValue = str2double(theLine(a(strPos):b(strPos)));
                i=i+1;
                trainingError2(i) = nValue;
            catch e
                % Ignore lines we can't read
            end
        end
    end
    fclose(fp2);
else
    fprintf('Can not find the demo training log\n');
end

for i=1:size(trainingError2, 2)
    avgTrainingError2(i) = sum(trainingError2(1:i))/i;
end
hold on
plot(trainingError2, 'r')

title('Train Loss Per Sample');
xlabel('Epoch Number');

ylabel('Average Error Rate (training data)');

%% 
print -dpng SimpleDemoErrorRate

