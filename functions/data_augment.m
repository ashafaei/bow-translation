function [ nXs, nYs, weights] = data_augment( Xs, Ys, transitions, augment_weight, include_self)
% DATA_AUGMENT Augment action BoWs given transition matrices.
%
% ----
% Alireza & Ankur

num_transitions      = size(transitions, 1);
num_train_instances  = size(Xs, 2);
num_words            = size(Xs, 1);

% Allocating memory for the output.
nXs = zeros(num_words, num_train_instances*(num_transitions+1));
nYs = zeros(num_train_instances*(num_transitions+1), 1);
weights = ones(numel(nYs), 1);

% Normalize in case Xs is not normalized.
Xs_orig   = Xs ./ repmat( sqrt(sum(Xs.^2, 1)), num_words, 1);

nXs(:, 1:num_train_instances) = Xs_orig;
nYs(1:num_train_instances, 1) = Ys;

for i=1:num_transitions,
    transition_matrix = full(transitions{i, 1});
    
    % Normalize the trasition matrix along the columns.
    normalized_tmat   = (transition_matrix ./ repmat(sum(transition_matrix, 2)+eps, 1, num_words))';
    new_vals          = normalized_tmat * Xs;
    
    % L2 normalization for the final BoW
    normalizer        = sqrt(sum(new_vals.^2));
    new_vals          = bsxfun(@rdivide, double(new_vals), normalizer + eps);
    
    nXs (:, i*num_train_instances+1:(i+1)*num_train_instances) = new_vals;
    nYs (i*num_train_instances+1:(i+1)*num_train_instances, 1) = Ys;
    weights (i*num_train_instances+1:(i+1)*num_train_instances, 1) = augment_weight(i);
end

if ~include_self,
    nXs     = nXs(:, num_train_instances+1:end);
    nYs     = nYs(num_train_instances+1:end);
    weights = weights(num_train_instances+1:end);
end