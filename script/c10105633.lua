function c10105633.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10105633)
	aux.AddLinkProcedure(c,c10105633.mfilter,1,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105633,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1,10105633)
	e1:SetCondition(c10105633.condition)
	e1:SetTarget(c10105633.target)
	e1:SetOperation(c10105633.operation)
	c:RegisterEffect(e1)
    	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105633,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10105633.rmtg)
	e2:SetOperation(c10105633.rmop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105633,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c10105633.setcon)
	e3:SetTarget(c10105633.settg)
	e3:SetOperation(c10105633.setop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
    end
function c10105633.mfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsLevelAbove(7)
end
function c10105633.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10105633.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT+RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c10105633.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10105633.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10105633.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10105633.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10105633.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c10105633.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c10105633.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c10105633.filter(chkc) end
	if chk==0 then return true end
	e:SetLabelObject(nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10105633.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c10105633.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and not tc:IsType(TYPE_TOKEN) and e:GetHandler():IsRelateToEffect(e) then
			e:SetLabelObject(tc)
			tc:RegisterFlagEffect(10105633,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function c10105633.setcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	return tc and tc:GetFlagEffect(10105633)~=0
end
function c10105633.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject():GetLabelObject()
	Duel.SetTargetCard(tc)
	if tc:IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	else
		e:SetCategory(0)
	end
end
function c10105633.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		Duel.SSet(tp,tc,1-tp)
	end
end