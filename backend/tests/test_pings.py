def test_post_then_get_pings(client):
    post = client.post("/api/pings")
    assert post.status_code == 201
    body = post.json()
    assert "id" in body
    assert "created_at" in body

    get = client.get("/api/pings")
    assert get.status_code == 200
    arr = get.json()
    assert len(arr) == 1
    assert "id" in arr[0]
    assert "created_at" in arr[0]
