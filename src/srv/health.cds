@path: '/'
service HealthCheck {
    entity health {
        key pid    : Integer;
            status : String;
    }

}
