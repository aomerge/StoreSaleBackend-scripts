CREATE TABLE permissions (        
    permission_id BIGSERIAL PRIMARY KEY,

    userGroup_id BIGINT NOT NULL,
    moduleName_id BIGINT NOT NULL,
    permission INTEGER NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,

    CONSTRAINT fk_permissions_user_group
        FOREIGN KEY (userGroup_id)
        REFERENCES user_groups (id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_permissions_module_name
        FOREIGN KEY (moduleName_id)
        REFERENCES module_names (id) 
        ON DELETE CASCADE

);