close all;clear;clc;bdclose all;

load_system('CDCJournalModel');

try
    p.ic = 'wide';
    p.KLearningNewton = 0.1;
    p.windVariant = 1;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'wide';
    p.KLearningNewton = 0.2;
    p.windVariant = 1;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'wide';
    p.KLearningNewton = 0.3;
    p.windVariant = 1;
    sim('CDCJournalModel')
catch
end
try
    p.ic = 'short';
    p.KLearningNewton = 0.1;
    p.windVariant = 1;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'short';
    p.KLearningNewton = 0.2;
    p.windVariant = 1;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'short';
    p.KLearningNewton = 0.3;
    p.windVariant = 1;
    sim('CDCJournalModel')
catch
end
try
    p.ic = 'wide';
    p.KLearningNewton = 0.1;
    p.windVariant = 3;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'wide';
    p.KLearningNewton = 0.2;
    p.windVariant = 3;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'wide';
    p.KLearningNewton = 0.3;
    p.windVariant = 3;
    sim('CDCJournalModel')
catch
end
try
    p.ic = 'short';
    p.KLearningNewton = 0.1;
    p.windVariant = 3;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'short';
    p.KLearningNewton = 0.2;
    p.windVariant = 3;
    sim('CDCJournalModel')
catch
end

try
    p.ic = 'short';
    p.KLearningNewton = 0.3;
    p.windVariant = 3;
    sim('CDCJournalModel')
catch
end

