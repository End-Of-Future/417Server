--幻星集 女皇
function c66060003.initial_effect(c)
	aux.EnablePendulumAttribute(c)
--pscale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c66060003.sccon1)
	e1:SetValue(-3)
	c:RegisterEffect(e1)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e8)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c66060003.sccon2)
	e2:SetValue(4)
	c:RegisterEffect(e2)
	local e9=e2:Clone()
	e9:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e9)
--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66060003,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,66060003)
	e3:SetCondition(c66060003.spcon)
	e3:SetTarget(c66060003.sptg)
	e3:SetOperation(c66060003.spop)
	c:RegisterEffect(e3)
--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,66050002)
	e4:SetTarget(c66060003.thtg)
	e4:SetOperation(c66060003.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
--to extra
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOEXTRA)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,66050003)
	e6:SetCost(c66060003.hxjcost)
	e6:SetCondition(c66060003.sccon2)
	e6:SetTarget(c66060003.tetg)
	e6:SetOperation(c66060003.teop)
	c:RegisterEffect(e6)
--remove
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCountLimit(1)
	e7:SetCost(c66060003.hxjcost)
	e7:SetCondition(c66060003.sccon3)
	e7:SetTarget(c66060003.rmtg)
	e7:SetOperation(c66060003.rmop)
	c:RegisterEffect(e7)
--cannot be material
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e10:SetValue(c66060003.splimit)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e13)
end
function c66060003.hxjcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetControler()==e:GetHandler():GetOwner() then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66060003.hxjlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) end
end
function c66060003.hxjlimit(e,c)
	return not c:IsSetCard(0x660)
end
function c66060003.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x660)
end

function c66060003.sccon1(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) 
end
function c66060003.sccon2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1) 
end
function c66060003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x660)
end
function c66060003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66060003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66060003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66060003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c66060003.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x660) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c66060003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c66060003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66060003.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66060003.tefilter(c)
	return c:IsSetCard(0x660) and not c:IsCode(66060003) and c:IsType(TYPE_PENDULUM)
end
function c66060003.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66060003.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c66060003.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66060003,1))
	local g=Duel.SelectMatchingCard(tp,c66060003.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c66060003.sccon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) 
end
function c66060003.rmfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x660)
		and not c:IsCode(66060003) and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c66060003.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c66060003.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66060003.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end end