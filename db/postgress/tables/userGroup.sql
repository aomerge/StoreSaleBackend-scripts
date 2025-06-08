CREATE TABLE user_groups (
    user_group_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT fk_user_groups_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE, -- O la acción que prefieras ON DELETE/ON UPDATE
    CONSTRAINT fk_user_groups_group
        FOREIGN KEY (group_id)
        REFERENCES groups (group_id) 
        ON DELETE CASCADE  
);