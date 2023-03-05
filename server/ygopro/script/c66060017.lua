--幻星集星星
function c66060017.initial_effect(c)
	aux.EnablePendulumAttribute(c)
--pscale
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c66060017.sccon1)
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
	e2:SetCondition(c66060017.sccon2)
	e2:SetValue(4)
	c:RegisterEffect(e2)
	local e9=e2:Clone()
	e9:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e9)
--break
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetCountLimit(1,c66050028)
	e3:SetCondition(c66060017.sccon1)
	e3:SetTarget(c66060017.target1)
	e3:SetOperation(c66060017.activate1)
	c:RegisterEffect(e3)
--destory
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,c66050017)
	e4:SetCost(c66060017.hxjcost)
	e4:SetCondition(c66060017.sccon2)
	e4:SetTarget(c66060017.target)
	e4:SetOperation(c66060017.activate)
	c:RegisterEffect(e4)
--flip
  local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,c66060017)
	e5:SetTarget(c66060017.target2)
	e5:SetOperation(c66060017.operation2)
	c:RegisterEffect(e5)
--tuner
local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66060017,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c66060017.tntg)
	e6:SetOperation(c66060017.tnop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
--cannot be material
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e10:SetValue(c66060017.splimit)
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
function c66060017.hxjcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetControler()==e:GetHandler():GetOwner() then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66060017.hxjlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) end
end
function c66060017.hxjlimit(e,c)
	return not c:IsSetCard(0x660)
end
function c66060017.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x660)
end
function c66060017.filter2(c,e,tp)
	return c:IsSetCard(0x660) and not c:IsCode(66060017) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66060017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66060017.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c66060017.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c66060017.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if tc1 and Duel.SelectOption(tp,aux.Stringid(66060017,1),aux.Stringid(66060017,2))==0 then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
		tc1:RegisterFlagEffect(66060017,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc1)
		e1:SetCondition(c66060017.dscon)
		e1:SetOperation(c66060017.dsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		 Duel.ConfirmCards(1-tp,tc1)
	end
end
function c66060017.dscon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	return tc1:GetFlagEffectLabel(66060017)==e:GetLabel()
end
function c66060017.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	Duel.Destroy(tc1,POS_FACEUP,REASON_EFFECT)
end

function c66060017.sccon1(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) 
end
function c66060017.sccon2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1) 
end
function c66060017.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(tp)
end
function c66060017.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c66060017.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c66060017.filter1(c,e,tp)
	return c:IsSummonPlayer(tp)
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c66060017.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c66060017.filter1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_GRAVE)
	end end
--1
function c66060017.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,LOCATION_DECK)
end
function c66060017.filter3(c,e,tp)
		return c:IsSetCard(0x660) and c:IsAbleToHand()
end
function c66060017.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c66060017.filter3,nil,e,tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(66060017,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c66060017.filter3,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		g:Sub(sg)
	end
	end
end

function c66060017.tnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x660) and c:IsLevelAbove(0) and not c:IsType(TYPE_TUNER)
end
function c66060017.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66060017.tnfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66060017.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66060017.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
end end