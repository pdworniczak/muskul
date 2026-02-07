package pl.muskul.training;

import static pl.muskul.training.TrainingConfiguration.CORE_TRAINING;
import static pl.muskul.training.TrainingConfiguration.CHEST_TRAINING;
import static pl.muskul.training.TrainingConfiguration.STRECH_TRAINING;

import pl.muskul.training.data.Training;
import pl.muskul.training.data.TrainingType;

public class TrainingService {

    public Training getTraining(TrainingType type) {
        switch(type) {
            case CORE: return CORE_TRAINING;
            case CHEST: return CHEST_TRAINING;
            case STRETCH: return STRECH_TRAINING;
        }

        throw new Error("Unsuported training type ".concat(type.toString()));
    }
}
