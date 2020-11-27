defmodule Gibon.SerialTest do
  use Gibon.DataCase

  alias Gibon.Serial

  describe "devices" do
    alias Gibon.Serial.Device

    @valid_attrs %{port: "some port", product_id: 42}
    @update_attrs %{port: "some updated port", product_id: 43}
    @invalid_attrs %{port: nil, product_id: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Serial.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Serial.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Serial.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Serial.create_device(@valid_attrs)
      assert device.port == "some port"
      assert device.product_id == 42
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Serial.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = Serial.update_device(device, @update_attrs)
      assert device.port == "some updated port"
      assert device.product_id == 43
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Serial.update_device(device, @invalid_attrs)
      assert device == Serial.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Serial.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Serial.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Serial.change_device(device)
    end
  end
end
