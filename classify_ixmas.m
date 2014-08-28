%% This script perform multi-view classification on the IXMAS dataset!
% There are 5 camera settings, we learn on a camera and then perform action
% recognition on the other cameras. The result is a 5x5 matrix of
% accuracies.
% - Alireza

addpath(genpath('./functions/'));
%% Configuration

script_config = struct();

script_config.base_path      = './'; % You must run this script from the root folder.
script_config.dataset_base   = [script_config.base_path 'dataset/'];
script_config.ixmas_base     = [script_config.dataset_base 'IXMAS_06/'];

script_config.vocab_size     = 2000; % The size of the vocabulary we used for these experiments.

script_config.transitions_path = [script_config.dataset_base '/transition_matrices/'];
% We only use a subset of the transition matrices!
script_config.thetas  = [30 60 90]; % These are elevational angle changes.
script_config.phis    = [0 60 120 180 240 300]; % These are azimuthal angle changes.

script_config.augment_data              = true; % Whether we should augment the training data with rotated features.
script_config.augmented_constant_weight = 0.01; % What should be the constant weight for these new instances?
script_config.augment_include_self      = true; % Whether we should include the original feature.

script_config.SVM_c = 1; % The margin parameter for SVM

script_config.homker_kernel = 1; % Whether we should use Homogenous Kernel Maps.

    
%% Initialization - Load the matrices and set parameters.

accuracies       = zeros(5, 5);
class_accuracies = zeros(5, 5, 12);

transitions = read_sparse_transitions(script_config.transitions_path, script_config.thetas, script_config.phis); 

% Update the weights to match the number of transitions.
script_config.augment_weight = script_config.augmented_constant_weight * ones(size(transitions, 1), 1);


%% Main - Where all the magic happens!
% We need to train on one cam and test on other cams.

for train_cam = 0:4,
    
    % First load the training data!
    train_data = load(sprintf('%sbaseline_common_dict/data_cam%d_bow%d.mat',...
                                script_config.ixmas_base, train_cam, script_config.vocab_size));
    
    Ys_orig = train_data.labels';    
    Xs_orig = train_data.desc;
    n_features = numel(Ys_orig);
    
    if script_config.augment_data
        [Xs, Ys, weights] = data_augment(Xs_orig, Ys_orig, active_trans, ...
                                        script_config.augment_weight, script_config.augment_include_self);
    else
        Xs = Xs_orig;
        Ys = Ys_orig;
        weights = ones(size(Ys));
    end
    
    % Run the homogenous kernel maps of VLFeat
    Xs = vl_homkermap(Xs, script_config.homker_kernel)';
   
    fprintf('Training SVM ... '); tic;
    model = train_liblinear_weights(weights, Ys, sparse(Xs), sprintf('-c %d -q', script_config.SVM_c));
    fprintf('%.2fs\n', toc);
    
    for test_cam = 0:4
        if test_cam == train_cam
            class_accuracies (train_cam + 1, test_cam + 1, :) = -1;

            continue;
        end
        
        fprintf('Doing %d -> %d =', train_cam, test_cam); tic;
        
        test_data = load(sprintf('%sbaseline_common_dict/data_cam%d_bow%d.mat',...
                                    script_config.ixmas_base, test_cam, script_config.vocab_size));        
        
        % We directly use the training data without augmentations.
        Yt_orig = test_data.labels';    
        Xt_orig = test_data.desc;
    
        Xt = vl_homkermap(Xt_orig, script_config.homker_kernel)';
        
        [pl, acc, margins] = predict_liblinear_weights(Yt_orig, sparse(Xt), model);
        
        accuracies(train_cam +1, test_cam +1) = acc(1);

        % Calculating per class accuracies,
        classes = unique(Yt_orig);
        for c= 1:numel(classes),
            class_labels = (Yt_orig == classes(c));
            class_count  = sum(class_labels);
            
            correct      = (Yt_orig == classes(c)) & (pl == classes(c));
            correct_count= sum(correct);
            
            class_accuracies (train_cam + 1, test_cam + 1, classes(c)) = correct_count / class_count;
        end
        
        fprintf(' %.2f in %.2fs\n', acc(1), toc);
    end
    
end

%% Conclusion!
% Note that there are only evleven actions!

class_accuracy = zeros(size(class_accuracies, 3), 1);

for c= 1:size(class_accuracies, 3),
    c_acc = [];
    for i = 1:size(class_accuracies, 1),
        for j= 1:size(class_accuracies, 2),
            if class_accuracies(i, j, c) ~= -1
                c_acc = [c_acc, class_accuracies(i, j, c)];
            end
        end
    end
    class_accuracy(c) = mean(c_acc);
end

fprintf('Average accuracy %.4f\n', sum(accuracies(:))/20);
