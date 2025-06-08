CREATE TABLE permissions (        
    permission_id BIGSERIAL PRIMARY KEY,

    userGroup_id BIGINT NOT NULL,
    moduleName_id BIGINT NOT NULL,
    permission INTEGER NOT NULL, -- Asumiendo que 'Number' se mapea a un tipo numérico como INTEGER
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,

    CONSTRAINT fk_permissions_user_group
        FOREIGN KEY (userGroup_id)
        REFERENCES user_groups (id) -- Asumiendo que la PK de 'user_groups' es 'id'
        ON DELETE CASCADE,
    CONSTRAINT fk_permissions_module_name
        FOREIGN KEY (moduleName_id)
        REFERENCES module_names (id) -- Asumiendo que la PK de 'module_names' es 'id'
        ON DELETE CASCADE,

    -- Opción 2: Si userGroup_id y moduleName_id deben ser únicos juntos (clave primaria compuesta)
    -- (Descomenta esto y comenta permission_id BIGSERIAL PRIMARY KEY si aplica)
    -- CONSTRAINT PK_permissions PRIMARY KEY (userGroup_id, moduleName_id)
);